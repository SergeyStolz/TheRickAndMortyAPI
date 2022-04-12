//
//  DetailCharacterView.swift
//  The Rick And Morty
//
//  Created by mac on 04.04.2022.
//

import UIKit
import EasyPeasy
import Kingfisher

class DetailCharacterView: UIView {
    
    // MARK: - Private views
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Character details"
        label.font = UIFont(name: "Hoefler Text", size: 22)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 5
        return imageView
    }()
    
    private lazy var idCharacterLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Hoefler Text", size: 20)
        return label
    }()
    
    private lazy var nameCharacterLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "Hoefler Text", size: 20)
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    private lazy var statusCharacterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Hoefler Text", size: 22)
        return label
    }()
    
    private lazy var statusCircleLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 6
        label.layer.masksToBounds = true
        return label
    }()
    
    private lazy var speciesCharacterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Hoefler Text", size: 22)
        return label
    }()
    
    private lazy var typeCharacterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Hoefler Text", size: 22)
        return label
    }()
    
    private lazy var genderCharacterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Hoefler Text", size: 22)
        return label
    }()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "multiply")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        return button
    }()
    
    var character: DetailCharacterProtocol! {
        didSet {
            setupCharacter(character)
        }
    }
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc
    private func buttonClicked() {
        fadeScaleTransform()
    }
    func setupView() {
        layer.cornerRadius = 10
        layer.borderWidth = 0.1
        layer.masksToBounds = false
        backgroundColor = .systemGray5
        layer.borderColor = UIColor.black.cgColor
        addShadow(
            color: UIColor.green.cgColor,
            shadowRadius: 25,
            shadowOpacity: 1
        )
        
        addSubview(scrollView)
        addSubview(dismissButton)
        scrollView.addSubview(nameCharacterLabel)
        scrollView.addSubview(characterImageView)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(statusCharacterLabel)
        scrollView.addSubview(statusCircleLabel)
        scrollView.addSubview(speciesCharacterLabel)
        scrollView.addSubview(typeCharacterLabel)
        scrollView.addSubview(genderCharacterLabel)
        
        scrollView.easy.layout( Top(), Bottom(), Width(350) )
        titleLabel.easy.layout( Top(5), CenterX(), Height(<=22) )
        dismissButton.easy.layout( Top(3), Right(3), Height(22), Width(22) )
        characterImageView.easy.layout( Top(4).to(titleLabel), Bottom(<=180), Height(380), CenterX(), Width(340))
        nameCharacterLabel.easy.layout( Top(10).to(characterImageView), CenterX(), Height(20), Width(<=300) )
        statusCharacterLabel.easy.layout( Top(15).to(nameCharacterLabel), Left(13), Right(13), Height(<=22) )
        speciesCharacterLabel.easy.layout(Top(10).to(statusCharacterLabel), Left(13),  Right(13), Height(<=22) )
        typeCharacterLabel.easy.layout( Top(10).to(speciesCharacterLabel), Left(13), Right(13), Height(<=22) )
        genderCharacterLabel.easy.layout( Top(10).to(typeCharacterLabel), Left(13), Right(13), Height(<=22) )
        statusCircleLabel.easy.layout( Top(10).to(characterImageView), Right(5).to(nameCharacterLabel), Height(10), Width(10) )
    }
    
    private func setupCharacter(_ character: DetailCharacterProtocol!) {
        guard let item = character else { return }
        nameCharacterLabel.text = item.name
        speciesCharacterLabel.text = "Species: \(item.species)"
        statusCharacterLabel.text = "Status: \(item.status)"
        genderCharacterLabel.text = "Gender: \(item.gender)"
        idCharacterLabel.text = "\(item.id)"
        
        let stateCharacter = StatusChar.init(rawValue: item.status)
        switch stateCharacter {
        case .alive:
            statusCircleLabel.backgroundColor = .green
        case .unknown:
            statusCircleLabel.backgroundColor = .brown
        case .dead:
            statusCircleLabel.backgroundColor = .red
        case .none:
            break
        }
        
        if item.type == "" {
            typeCharacterLabel.text = "Type: Unknow"
        } else {
            typeCharacterLabel.text = "Type: \(item.type)"
        }
        
        let characterImageString = item.image
        DispatchQueue.main.async {
            guard let url = URL(string: characterImageString) else { return }
            self.characterImageView.kf.indicatorType = .activity
            self.characterImageView.kf.setImage(with: url)
        }
    }
}
