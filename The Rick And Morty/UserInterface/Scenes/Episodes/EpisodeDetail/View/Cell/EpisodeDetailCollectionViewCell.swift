//
//  EpisodeDetailCollectionViewCell.swift
//  The Rick And Morty
//
//  Created by mac on 05.04.2022.
//

import UIKit
import EasyPeasy
import Kingfisher

class EpisodeDetailCell: UICollectionViewCell {
    static let identifier = "CustomEpisodCollectionViewCell"
    
    private lazy var characterImageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var nameCharacterLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.font = UIFont(name: "Hoefler Text", size: 20)
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    private var speciesCharacterLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    private var statusCharacterLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemBackground
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
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(characterImageView)
        contentView.addSubview(nameCharacterLabel)
        contentView.addSubview(speciesCharacterLabel)
        contentView.addSubview(statusCharacterLabel)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        characterImageView.easy.layout( Edges() )
//        statusCharacterLabel.easy.layout( Top(10).to(speciesCharacterLabel), Left(10).to(characterImageView), Width(<=100), Height(<=20) )
//        statusCircleLabel.easy.layout( Top(12).to(nameCharacterLabel), Left(5).to(statusCharacterLabel), Height(10), Width(10) )
//        nameCharacterLabel.easy.layout( Top(20), Left(10).to(characterImageView), Right(5), Height(<=20) )
//        speciesCharacterLabel.easy.layout( Top(5).to(nameCharacterLabel), Left(10).to(characterImageView), Right(5), Height(<=20) )
        contentView.backgroundColor = .systemBackground
    }
    
    func fill(item: SearchRespondEpisodCharacter) {
        nameCharacterLabel.text = item.name
        speciesCharacterLabel.text = item.species
        statusCharacterLabel.text = " \(item.status) "
        
        if item.status == "Alive" {
            statusCharacterLabel.backgroundColor = .green
            statusCharacterLabel.textColor = .white
        } else if item.status == "unknown" {
            statusCharacterLabel.backgroundColor = .brown
            statusCharacterLabel.textColor = .white
        }  else if item.status == "Dead" {
            statusCharacterLabel.backgroundColor = .red
            statusCharacterLabel.textColor = .white
        }
        
        let urlString = item.image
        guard let url = URL(string: urlString) else { return }
        characterImageView.kf.indicatorType = .activity
        characterImageView.kf.setImage(with: url)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameCharacterLabel.text = nil
        characterImageView.image = nil
        speciesCharacterLabel.text = nil
        statusCharacterLabel.text = nil
    }
}
