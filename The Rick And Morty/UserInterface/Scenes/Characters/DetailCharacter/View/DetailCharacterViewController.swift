//
//  DetailCharacterViewController.swift
//  The Rick And Morty
//
//  Created by mac on 05.04.2022.
//

import UIKit
import EasyPeasy

class DetailCharacterViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var presenter: DetailCharacterPresenter! = nil
    let pre: CharacterViewOutput! = nil
    var sss: SearchResponseCharacters?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textAlignment = .center
        label.font = UIFont(name: "Arial", size: 25)
        label.numberOfLines = 0
        return label
    }()
    
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
    
    private lazy var descriptionCharacterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Arial", size: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var exploreMoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Arial", size: 34)
        label.textAlignment = .left
        label.text = "Explore more"
        return label
    }()
    
    
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: compositionalLayout
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
//        collectionView.addShadow(color: UIColor.orange.cgColor, shadowRadius: 5, shadowOpacity: 0.5)
        return collectionView
    }()
    
    let compositionalLayout: UICollectionViewCompositionalLayout = {
        let fraction: CGFloat = 1.0 / 3.0
        
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalWidth(fraction))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 2.5, bottom: 0, trailing: 2.5)
        section.orthogonalScrollingBehavior = .continuous
        
        section.visibleItemsInvalidationHandler = { (items, offset, environment) in
            items.forEach { item in
                let distanceFromCenter = abs((item.frame.midX - offset.x) - environment.container.contentSize.width / 2.0)
                let minScale: CGFloat = 0.6
                let maxScale: CGFloat = 1.1
                let scale = max(maxScale - (distanceFromCenter / environment.container.contentSize.width), minScale)
                item.transform = CGAffineTransform(scaleX: scale, y: scale)
            }
        }
        
        return UICollectionViewCompositionalLayout(section: section)
    }()
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.getCharacters()
        setupViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        titleLabel.removeFromSuperview()
    }
    
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(collectionView)
        scrollView.addSubview(characterImageView)
        scrollView.addSubview(descriptionCharacterLabel)
        scrollView.addSubview(exploreMoreLabel)
        
        
        guard let navigationBar = self.navigationController?.navigationBar else { return }
//        title = presenter.data.name
        navigationBar.topItem!.title = ""
        navigationBar.tintColor = UIColor.green
        
        navigationBar.addSubview(titleLabel)
        titleLabel.text = presenter.data.name
        titleLabel.setLineSpacing(lineSpacing: 0,
                                  lineHeightMultiple: 0,
                                  characterSpacing: -0.41)
        titleLabel.easy.layout(
            CenterX(),
            Top(11),
            Height(30),
            Width(<=300)
        )
        
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
        
        descriptionCharacterLabel.easy.layout(
            Top(16).to(characterImageView),
            Left(16),
            Right(16),
            Height(>=0),
            Width(view.frame.size.width)
        )
        descriptionCharacterLabel.text = presenter.data.gender
        descriptionCharacterLabel.setLineSpacing(lineSpacing: 0,
                                                 lineHeightMultiple: 1.3,
                                                 characterSpacing: -0.41
        )
        
        exploreMoreLabel.easy.layout(
            Top(18).to(descriptionCharacterLabel),
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
        
        let urlString = presenter.data.image
        guard let url = URL(string: urlString)  else { return }
        if let data = NSData(contentsOf: url) {
            characterImageView.image = UIImage(data: data as Data)!
        }
        view.backgroundColor = #colorLiteral(red: 0.1215521768, green: 0.1215801314, blue: 0.1215485111, alpha: 0.9396283223)
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
//    var char: [ResultsCharacter]? = nil
//
//    override func viewWillAppear(_ animated: Bool) {
//        guard var char = presenter.characters?.results else { return cell }
//        char.shuffle()
//    }
    
    var char: ResultsCharacter? = nil

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCharacterCollectionViewCell.identifier, for: indexPath) as! DetailCharacterCollectionViewCell
        guard var char = presenter.characters?.results else { return cell }
        char.shuffle()
        guard let character = presenter.characters?.results[indexPath.item] else { return cell }
        
        
        cell.filll(item: char[indexPath.item])
        cell.addShadow(color: UIColor.green.cgColor, shadowRadius: 7, shadowOpacity: 0.4)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let character = presenter.characters?.results[indexPath.item]
        
        let data = character
        let characterDetail = DetailCharacterViewController()
        characterDetail.char = data
       
        navigationController?.pushViewController(characterDetail, animated: true)
    
}
    
    func succes() {
        self.collectionView.reloadData()
    }
    
    func failure(error: Error) {
    }
}

extension UILabel {
    func setLineSpacing(lineSpacing: CGFloat,
                        lineHeightMultiple: CGFloat,
                        characterSpacing: CGFloat) {
        
        guard let labelText = self.text else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.kern, value: characterSpacing, range: NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
    }
}
