//
//  EpisodCollectionViewCell.swift
//  The Rick And Morty
//
//  Created by mac on 05.04.2022.
//

import UIKit
import EasyPeasy

class EpisodCell: UICollectionViewCell {
    static let identifier = "CustomEpisodCollectionViewCell"
    
    // MARK: - Private Views
    private var nameEpisodeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont(name: "Arial", size: 28)
        label.numberOfLines = 0
        label.textColor = .systemGray
        return label
    }()
    
    private var imageCircleEpisodeImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "epis")
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageCircleEpisodeImageView)
        contentView.addSubview(nameEpisodeLabel)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameEpisodeLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageCircleEpisodeImageView.easy.layout( Edges() )
        nameEpisodeLabel.easy.layout( Bottom(5), CenterX(), Height(50), Left(15), Right(15) )
        imageCircleEpisodeImageView.layer.cornerRadius = 15
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(label: String) {
        nameEpisodeLabel.text = label
    }
}


