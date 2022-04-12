//
//  CharactersTableViewCell.swift
//  The Rick And Morty
//
//  Created by user on 30.03.2022.
//
import UIKit
import EasyPeasy
import RealmSwift
import Kingfisher

protocol CharacterCellDelegat: AnyObject {
    func infoStateDelegate(name: String, state: Bool)
}

class CharacterCollectionViewCell: UICollectionViewCell {
    static let identifier = "CustomCollectionViewCell"
    
    weak var delegate: CharacterCellDelegat?
    
    // MARK: - Private propierties
    private var state = Bool()
    private var characterId = 0
    private var statusCharacter = ""
    private var speciesCharacter = ""
    private var typeCharacter = ""
    private var genderCharacter = ""
    private var imageCharacter = ""
    
    private let realm = try! Realm()
    private lazy var items: Results<FavoritesRealmModel>! = {
        self.realm.objects(FavoritesRealmModel.self)
    }()
    
    // MARK: - Private Views
    private lazy var characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var nameCharacterLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGray5
        label.textAlignment = .center
        label.font = UIFont(name: "Hoefler Text", size: 21)
        label.numberOfLines = 0
        label.layer.zPosition = 1
        return label
    }()
    
    private lazy var isFavoriteImageStar: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "star.fill")?
            .withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .black
        return imageView
    }()
    
    private lazy var isFavoriteButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(setupIsFavouriteButtonColor),for: .touchUpInside)
        button.addShadow(color: UIColor.green.cgColor, shadowRadius: 4, shadowOpacity: 0.7)
        return button
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(nameCharacterLabel)
        contentView.addSubview(characterImageView)
        contentView.addSubview(isFavoriteButton)
        isFavoriteButton.addSubview(isFavoriteImageStar)
        contentView.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        characterImageView.easy.layout( Edges() )
        isFavoriteButton.easy.layout( Left(4), Top(4),  Width(23), Height(23) )
        isFavoriteImageStar.easy.layout( Edges() )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameCharacterLabel.text = nil
        characterImageView.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - SetupIsFavouriteButtonColor
extension CharacterCollectionViewCell {
    @objc private func setupIsFavouriteButtonColor(sender:UIButton) {
        if sender.tag == isFavoriteButton.tag {
            if isFavoriteButton.isSelected {
                isFavoriteImageStar.image = UIImage(
                    systemName: "star.fill")?.withRenderingMode(.alwaysTemplate)
                isFavoriteImageStar.tintColor = .black
                isFavoriteButton.isSelected = false
                state = false
            } else {
                isFavoriteImageStar.image = UIImage(
                    systemName: "star.fill")?.withRenderingMode(.alwaysTemplate)
                isFavoriteImageStar.tintColor = .systemGreen
                isFavoriteButton.isSelected = true
                state = true
            }
            delegate?.infoStateDelegate(name: nameCharacterLabel.text ?? "", state: state)
        }
        configureFavoriteCharacter()
    }
}

// MARK: - Realm
extension CharacterCollectionViewCell {
    private func configureFavoriteCharacter() {
        let realmModel: FavoritesRealmModel!
        realmModel = FavoritesRealmModel()
        realmModel.id = characterId
        realmModel.nameCharacter = nameCharacterLabel.text!
        realmModel.statusCharacter = statusCharacter
        realmModel.speciesCharacter = speciesCharacter
        realmModel.typeCharacter = typeCharacter
        realmModel.genderCharacter = genderCharacter
        realmModel.state = state
        realmModel.imageCharacter = imageCharacter
        if isFavoriteButton.isSelected {
            setFavoriteCharacter(model: realmModel)
        } else {
            deleteFavoriteCharacter(model: realmModel)
        }
    }
    
    private func setFavoriteCharacter(model: FavoritesRealmModel) {
        let realm = try? Realm()
        try? realm?.write {
            realm?.add(model)
        }
    }
    
    private func deleteFavoriteCharacter(model: FavoritesRealmModel) {
        let realmModel: FavoritesRealmModel!
        realmModel = FavoritesRealmModel()
        realmModel.id = characterId
        do {
            let realm = try Realm()
            let object = realm.objects(FavoritesRealmModel.self)
                .filter({$0.id == self.characterId}).first
            try! realm.write {
                if let obj = object {
                    realm.delete(obj)
                }
            }
        } catch let error as NSError {
            print("error - \(error.localizedDescription)")
        }
    }
}

// MARK: - FillCharacter
extension CharacterCollectionViewCell {
    func fillCharacter(item: CharactersCellViewModel) {
        nameCharacterLabel.text = item.name
        characterId = item.id
        statusCharacter = item.status
        speciesCharacter = item.species
        typeCharacter = item.type
        genderCharacter = item.gender
        setFavoriteButton(isFavorite: item.isFavorite)
        imageCharacter = item.image
        guard let url = URL(string: imageCharacter) else { return }
        characterImageView.kf.indicatorType = .activity
        characterImageView.kf.setImage(with: url)
    }
}

// MARK: - FillSearch
extension CharacterCollectionViewCell {
    func fillSearch(item: SearchCharactersViewModel) {
        nameCharacterLabel.text = item.name
        characterId = item.id
        statusCharacter = item.status
        speciesCharacter = item.species
        typeCharacter = item.type
        genderCharacter = item.gender
        setFavoriteButton(isFavorite: item.isFavorite)
        imageCharacter = item.image
        guard let url = URL(string: imageCharacter) else { return }
        characterImageView.kf.indicatorType = .activity
        characterImageView.kf.setImage(with: url)
    }
}

// MARK: - SetFavoriteButton
extension CharacterCollectionViewCell {
    func setFavoriteButton(isFavorite: Bool) {
        if !isFavorite {
            isFavoriteImageStar.image = UIImage(
                systemName: "star.fill")?.withRenderingMode(.alwaysTemplate)
            isFavoriteImageStar.tintColor = .black
            isFavoriteButton.isSelected = false
            state = false
        } else {
            isFavoriteImageStar.image = UIImage(
                systemName: "star.fill")?.withRenderingMode(.alwaysTemplate)
            isFavoriteImageStar.tintColor = .systemGreen
            isFavoriteButton.isSelected = true
            state = true
        }
    }
}
