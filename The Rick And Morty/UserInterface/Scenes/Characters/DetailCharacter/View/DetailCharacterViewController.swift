//
//  DetailCharacterViewController.swift
//  The Rick And Morty
//
//  Created by mac on 05.04.2022.
//

import UIKit
import EasyPeasy
import Kingfisher

class DetailCharacterViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - Propierties
    var presenter: DetailCharacterOutput!
    
    // MARK: - Private Views
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    
    private lazy var characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var exploreMoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Arial", size: 34)
        label.textAlignment = .left
        label.text = "Explore more"
        label.textColor = UIColor.gray
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: DetailCharacterViewController.createLayout()
        )
        collectionView.register(
            DetailCharacterCollectionViewCell.self,
            forCellWithReuseIdentifier: DetailCharacterCollectionViewCell.identifier
        )
        collectionView.backgroundColor = #colorLiteral(red: 0.1215521768, green: 0.1215801314, blue: 0.1215485111, alpha: 0.9396283223)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.clipsToBounds = false
        collectionView.layer.masksToBounds = false
        return collectionView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavAndTabBars()
        setupViews()
        fill()
    }
    
    private func setupViews() {
        view.backgroundColor = #colorLiteral(red: 0.1215521768, green: 0.1215801314, blue: 0.1215485111, alpha: 0.9396283223)
        view.addSubview(scrollView)
        scrollView.addSubview(collectionView)
        scrollView.addSubview(characterImageView)
        scrollView.addSubview(exploreMoreLabel)
        
        scrollView.easy.layout(
            Top(),
            Bottom(),
            Width(view.frame.size.width)
        )
        characterImageView.easy.layout(
            Top(15),
            Height(375),
            Width(view.frame.size.width)
        )
        
        exploreMoreLabel.easy.layout(
            Top(30).to(characterImageView),
            Left(16),
            Height(34),
            Width(<=210)
        )
        collectionView.easy.layout(
            Top(18).to(exploreMoreLabel),
            Width(view.frame.size.width),
            Height(120),
            Bottom(44)
        )
    }
    
    private func setupNavAndTabBars() {
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.isHidden = false
        navigationItem.title = presenter.currentCharacter?.name
        navigationBar.topItem!.title = ""
        navigationBar.tintColor = UIColor.green
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.1215686275, alpha: 0.9396283223)
        navigationController?.navigationBar.addShadow(
            color: UIColor.green.cgColor,
            shadowRadius: 0.6,
            shadowOpacity: 0.3
        )
    }
    
    private func fill() {
        guard let item = presenter.currentCharacter else { return }
        DispatchQueue.main.async {
            let urlString = item.image
            guard let url = URL(string: urlString) else { return }
            self.characterImageView.kf.indicatorType = .activity
            self.characterImageView.kf.setImage(with: url)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension DetailCharacterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCharacterCollectionViewCell.identifier, for: indexPath) as! DetailCharacterCollectionViewCell
        
        guard let character = presenter.allCharacters?[indexPath.item] else { return cell }
        cell.filll(item: character)
        cell.addShadow(color: UIColor.green.cgColor, shadowRadius: 7, shadowOpacity: 0.4)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension DetailCharacterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let currentCharacter = presenter.allCharacters?[indexPath.item] else { return }
        guard let allCharacters = presenter.allCharacters else { return }
        let characterDetail = CharacterDetailConfigurator.create(currentCharacter: currentCharacter, allCharacters: allCharacters)
        navigationController?.pushViewController(characterDetail, animated: true)
    }
}

// MARK: - Create Layout
extension DetailCharacterViewController {
    static func createLayout() -> UICollectionViewCompositionalLayout {
        let fraction: CGFloat = 1.0 / 3.0
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(fraction),
            heightDimension: .fractionalWidth(fraction))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 2.5,
            bottom: 0,
            trailing: 2.5)
        section.orthogonalScrollingBehavior = .continuous
        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
            items.forEach { item in
                let distanceFromCenter = abs(
                    (item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
                let minScale: CGFloat = 0.6
                let maxScale: CGFloat = 1.1
                let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - DetailCharacterInput
extension DetailCharacterViewController: DetailCharacterInput {
    func succes() {
        self.collectionView.reloadData()
    }
    
    func failure(error: Error) {
    }
}
