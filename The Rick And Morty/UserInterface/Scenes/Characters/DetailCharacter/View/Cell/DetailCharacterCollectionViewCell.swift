//
//  DetailCharacterCollectionViewCell.swift
//  The Rick And Morty
//
//  Created by mac on 05.04.2022.
//

import UIKit
import EasyPeasy
import RealmSwift
import Kingfisher

class DetailCharacterCollectionViewCell: UICollectionViewCell {
    static let identifier = "CustomCell"
    
    lazy var characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .green
        contentView.addSubview(characterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        characterImageView.easy.layout( Edges() )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        characterImageView.image = nil
    }
    
    func filll(item: ResultsCharacter) {
        let urlString = item.image
        guard let url = URL(string: urlString) else { return }
        characterImageView.kf.indicatorType = .activity
        characterImageView.kf.setImage(with: url)
    }
    
    func fill(item: SearchCharactersViewModel) {
        let urlString = item.image
        guard let url = URL(string: urlString) else { return }
        characterImageView.kf.indicatorType = .activity
        characterImageView.kf.setImage(with: url)
    }
    
    func config(image: String) {
        let urlString = image
        guard let url = URL(string: urlString) else { return }
        characterImageView.kf.indicatorType = .activity
        characterImageView.kf.setImage(with: url)
    }
}

//extension UIView {
//  func addShadow() {
//    self.layer.shadowColor = UIColor.black.cgColor
//    self.layer.shadowOffset = CGSize(width: -1, height: 2)
//    self.layer.shadowRadius = 1.8
//    self.layer.shadowOpacity = 0.3
//  }
//}
