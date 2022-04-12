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
    
    var state = Bool()
    var characterId = 0
    var statusCharacter = ""
    var speciesCharacter = ""
    var typeCharacter = ""
    var genderCharacter = ""
    
    weak var delegate: CharacterCellDelegat?
    
    private let realm = try! Realm()
    private lazy var items: Results<FavoritesRealmModel>! = {
        self.realm.objects(FavoritesRealmModel.self)
    }()
    
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
        button.addTarget(self,
                         action: #selector(setupIsFavouriteButtonColor),
                         for: .touchUpInside
        )
        button.addShadow(color: UIColor.green.cgColor, shadowRadius: 4, shadowOpacity: 0.7)
        return button
    }()
    
    @objc func setupIsFavouriteButtonColor(sender:UIButton) {
        if sender.tag == isFavoriteButton.tag {
            if isFavoriteButton.isSelected == true {
                isFavoriteImageStar.image = UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate)
                isFavoriteImageStar.tintColor = .black
                state = false
                isFavoriteButton.isSelected = false
            } else {
                isFavoriteImageStar.image = UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate)
                isFavoriteImageStar.tintColor = .systemGreen
                
                state = true
                isFavoriteButton.isSelected = true
            }
            delegate?.infoStateDelegate(name: nameCharacterLabel.text ?? "", state: state)
            
        }
        
        let realmModel: FavoritesRealmModel!
        realmModel = FavoritesRealmModel()
        
        realmModel.id = characterId
        realmModel.nameCharacter = nameCharacterLabel.text!
        realmModel.statusCharacter = statusCharacter
        realmModel.speciesCharacter = speciesCharacter
        realmModel.typeCharacter = typeCharacter
        realmModel.genderCharacter = genderCharacter
        realmModel.state = state
        guard let data = characterImageView.image!.pngData() else { return }
        realmModel.imageCharacter = data
        
        if isFavoriteButton.isSelected {
            setFavoriteCharacter(model: realmModel)
        } else {
            deleteFavoriteCharacter(model: realmModel)
        }
    }
    
    func setFavoriteCharacter(model: FavoritesRealmModel) {
        let realm = try? Realm()
        try? realm?.write {
            realm?.add(model)
        }
    }
    
    func deleteFavoriteCharacter(model: FavoritesRealmModel) {
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(nameCharacterLabel)
        contentView.addSubview(characterImageView)
        contentView.addSubview(isFavoriteButton)
        isFavoriteButton.addSubview(isFavoriteImageStar)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        characterImageView.easy.layout( Edges() )
        //        nameCharacterLabel.easy.layout( Left(), Right(), Bottom(), Height(45) )
        isFavoriteButton.easy.layout( Left(4), Top(4),  Width(23), Height(23) )
        isFavoriteImageStar.easy.layout( Edges() )
    }
    override func draw(_ rect: CGRect) {
        //        nameCharacterLabel.roundCorners([.bottomLeft, .bottomRight], radius: 12)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameCharacterLabel.text = nil
        characterImageView.image = nil
    }
    
    func fill(item: CharactersCellViewModel) {
        nameCharacterLabel.text = item.name
        characterId = item.id
        statusCharacter = item.status
        speciesCharacter = item.species
        typeCharacter = item.type
        genderCharacter = item.gender
        setFavoriteButton(isFavorite: item.isFavorite)
        
        let urlString = item.image
        guard let url = URL(string: urlString) else { return }
        characterImageView.kf.indicatorType = .activity
        characterImageView.kf.setImage(with: url)
    }
    
    func fill(item: SearchCharactersViewModel) {
        nameCharacterLabel.text = item.name
        characterId = item.id
        statusCharacter = item.status
        speciesCharacter = item.species
        typeCharacter = item.type
        genderCharacter = item.gender
        setFavoriteButton(isFavorite: item.isFavorite)
        
        let urlString = item.image
        guard let url = URL(string: urlString) else { return }
        characterImageView.kf.indicatorType = .activity
        characterImageView.kf.setImage(with: url)
    }
    
    func setFavoriteButton(isFavorite: Bool) {
        if isFavorite == false {
            isFavoriteImageStar.image = UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate)
            isFavoriteImageStar.tintColor = .black
            state = false
            isFavoriteButton.isSelected = false
        } else {
            isFavoriteImageStar.image = UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate)
            isFavoriteImageStar.tintColor = .systemGreen
            state = true
            isFavoriteButton.isSelected = true
        }
    }
}

