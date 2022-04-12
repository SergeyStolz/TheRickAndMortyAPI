//
//  DetailCharacterView.swift
//  The Rick And Morty
//
//  Created by mac on 04.04.2022.
//

import UIKit
import EasyPeasy

class DetailCharacterView: UIView {
    var searchViewModelList = [SearchCharactersViewModel]()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    lazy var titlePopUpLabel: UILabel = {
        let label = UILabel()
        label.text = "Character details"
        label.font = UIFont(name: "Hoefler Text", size: 22)
        label.textAlignment = .center
        return label
    }()
    
    lazy var characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    lazy var idCharacterLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Hoefler Text", size: 20)
        return label
    }()
    
    lazy var nameCharacterLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Hoefler Text", size: 20)
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    lazy var statusCharacterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Hoefler Text", size: 22)
        return label
    }()
    
    lazy var statusCircleLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 6
        label.layer.masksToBounds = true
        return label
    }()
    
    lazy var speciesCharacterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Hoefler Text", size: 22)
        return label
    }()
    
    lazy var typeCharacterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Hoefler Text", size: 22)
        return label
    }()
    
    lazy var genderCharacterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Hoefler Text", size: 22)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray5
        layer.masksToBounds = false
        addShadow(color: UIColor.green.cgColor, shadowRadius: 25, shadowOpacity: 1)
        layer.cornerRadius = 10
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 0.1
        
        addSubview(scrollView)
        scrollView.addSubview(nameCharacterLabel)
        scrollView.addSubview(characterImageView)
        scrollView.addSubview(titlePopUpLabel)
        scrollView.addSubview(statusCharacterLabel)
        scrollView.addSubview(statusCircleLabel)
        scrollView.addSubview(speciesCharacterLabel)
        scrollView.addSubview(typeCharacterLabel)
        scrollView.addSubview(genderCharacterLabel)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        scrollView.easy.layout( Top(), Bottom(), Width(350) )
        titlePopUpLabel.easy.layout( Top(5), CenterX(), Height(<=22) )
        characterImageView.easy.layout( Top(4).to(titlePopUpLabel), Bottom(<=180), Height(380), CenterX(), Width(340))
        nameCharacterLabel.easy.layout( Top(10).to(characterImageView), CenterX(), Height(20), Width(<=300) )
        statusCharacterLabel.easy.layout( Top(15).to(nameCharacterLabel), Left(13), Right(13), Height(<=22) )
        speciesCharacterLabel.easy.layout(Top(10).to(statusCharacterLabel), Left(13),  Right(13), Height(<=22) )
        typeCharacterLabel.easy.layout( Top(10).to(speciesCharacterLabel), Left(13), Right(13), Height(<=22) )
        genderCharacterLabel.easy.layout( Top(10).to(typeCharacterLabel), Left(13), Right(13), Height(<=22) )
        statusCircleLabel.easy.layout( Top(10).to(characterImageView), Right(5).to(nameCharacterLabel), Height(10), Width(10) )
    }
}
