//
//  FavoritesTableViewCell.swift
//  The Rick And Morty
//
//  Created by mac on 04.04.2022.
//

import UIKit
import EasyPeasy
import Kingfisher

class FavoritesTableViewCell: UITableViewCell {
    static let identifier = "CustomCollectionViewCell"
    
    // MARK: - Private Views
    private lazy var characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var nameCharacterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Hoefler Text", size: 20)
        label.font = .boldSystemFont(ofSize: 20)
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private var speciesCharacterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Hoefler Text", size: 18)
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private var statusCharacterLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.backgroundColor = .clear
        label.font = UIFont(name: "Hoefler Text", size: 18)
        label.textAlignment = .left
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var statusCircleLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 4
        label.layer.masksToBounds = true
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        characterImageView.image = nil
        nameCharacterLabel.text = nil
        speciesCharacterLabel.text = nil
        statusCharacterLabel.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupViews()
    }
    
    private func setupViews() {
        contentView.addSubview(characterImageView)
        contentView.addSubview(nameCharacterLabel)
        contentView.addSubview(speciesCharacterLabel)
        contentView.addSubview(statusCharacterLabel)
        contentView.addSubview(statusCircleLabel)
        contentView.clipsToBounds = true
        contentView.backgroundColor = #colorLiteral(red: 0.1215521768, green: 0.1215801314, blue: 0.1215485111, alpha: 0.9396283223)
        
        characterImageView.easy.layout(
            Top(5),
            Bottom(5),
            Left(5),
            Width(90)
        )
        statusCharacterLabel.easy.layout(
            Top(10).to(speciesCharacterLabel),
            Left(10).to(characterImageView),
            Height(20),
            Width(<=100)
        )
        statusCircleLabel.easy.layout(
            Top(12).to(nameCharacterLabel),
            Left(5).to(statusCharacterLabel),
            Height(10),
            Width(10)
        )
        nameCharacterLabel.easy.layout(
            Top(10),
            Left(10).to(characterImageView),
            Right(5),
            Height(<=20)
        )
        speciesCharacterLabel.easy.layout(
            Top(10).to(nameCharacterLabel),
            Left(10).to(characterImageView),
            Right(5),
            Height(<=20)
        )
    }
}

// MARK: - Fill
extension FavoritesTableViewCell {
    func fill(item: FavoritesCellViewModel) {
        nameCharacterLabel.text = item.name
        speciesCharacterLabel.text = item.species
        statusCharacterLabel.text = " \(item.status) "
        let urlString = item.image
        guard let url = URL(string: urlString) else { return }
        characterImageView.kf.indicatorType = .activity
        characterImageView.kf.setImage(with: url)
        
        let stateCharacter = StatusChar.init(rawValue: item.status)
        switch stateCharacter {
        case .alive:
            statusCharacterLabel.backgroundColor = .green
            statusCharacterLabel.textColor = .white
        case .unknown:
            statusCharacterLabel.backgroundColor = .brown
            statusCharacterLabel.textColor = .white
        case .dead:
            statusCharacterLabel.backgroundColor = .red
            statusCharacterLabel.textColor = .white
        case .none:
            break
        }
    }
}
