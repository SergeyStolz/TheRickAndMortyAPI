//
//  ViewController.swift
//  The Rick And Morty
//
//  Created by user on 30.03.2022.
//

import UIKit
import EasyPeasy
import Alamofire

class AllCharactersViewController: UIViewController {
    
    var presenter: CharacterViewOutput!
    
    private var charactersList: [CharacterResult]? = nil
    private let networkManager = NetworkReachabilityManager()
    private var loadAfterLostConnection = false
    private var lastOffset: Int = 1
    private var hasNextPage = true
    private var isState: Bool = false
    internal var searchViewModelList = [SearchCharactersViewModel]()
    
    // MARK: - Views
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(
            width: view.frame.width / 2.18,
            height:view.frame.width / 1.4
        )
        layout.sectionInset.left = 10
        layout.sectionInset.right = 10
        layout.sectionInset.top = 10
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: AllCharactersViewController.createLayout()
        )
        collectionView.register(
            CharacterCollectionViewCell.self,
            forCellWithReuseIdentifier: CharacterCollectionViewCell.identifier
        )
        collectionView.register(
            FooterCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: FooterCollectionReusableView.identifier
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.1215686275, alpha: 0.9396283223)
        return collectionView
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        return searchController
    }()
    
    
    static func createLayout() -> UICollectionViewCompositionalLayout {
        let mainItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(2/3),
                heightDimension: .fractionalHeight(1.0))
        )
        mainItem.contentInsets = NSDirectionalEdgeInsets(
            top: 1,
            leading: 1,
            bottom: 1,
            trailing: 1
        )
        let pairItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.5))
        )
        pairItem.contentInsets = NSDirectionalEdgeInsets(
            top: 1,
            leading: 1,
            bottom: 1,
            trailing: 1
        )
        let trailingGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(1.0)),
            subitem: pairItem,
            count: 2
        )
        let mainWithPairGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(4/9)),
            subitems: [mainItem, trailingGroup]
        )
        let tripletItem = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1/3),
                heightDimension: .fractionalHeight(1.0))
        )
        tripletItem.contentInsets = NSDirectionalEdgeInsets(
            top: 1,
            leading: 1,
            bottom: 1,
            trailing: 1
        )
        let tripletGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(2/9)),
            subitems: [tripletItem, tripletItem, tripletItem]
        )
        let mainWithPairReversedGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(4/9)),
            subitems: [trailingGroup, mainItem]
        )
        let nestedGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(16/9)),
            subitems: [mainWithPairGroup,tripletGroup,mainWithPairReversedGroup]
        )
        let section = NSCollectionLayoutSection(group: nestedGroup)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func viewTap() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.startListening()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        networkManager?.stopListening()
    }
    
    // Setup views functions
    private func setupViews() {
        setupNavBarAndTabBar()
        view.addSubview(searchController.searchBar)
        view.addSubview(collectionView)
        collectionView.easy.layout( Edges() )
    }
    
    private func setupNavBarAndTabBar() {
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.1215686275, alpha: 0.9396283223)
        tabBarController?.tabBar.barTintColor = #colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.1215686275, alpha: 0.9396283223)
        navigationController?.navigationBar.addShadow(
            color: UIColor.green.cgColor,
            shadowRadius: 0.6,
            shadowOpacity: 0.3
        )
    }
}

extension AllCharactersViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                                                     withReuseIdentifier: FooterCollectionReusableView.identifier,
                                                                     for: indexPath) as! FooterCollectionReusableView
        return footer
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var characterCount: Int = 0
        if isState {
            characterCount = presenter.searchCharacter?.count ?? 0
        }else {
            characterCount = presenter.charactersList?.count ?? 0
        }
        return characterCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.identifier, for: indexPath) as! CharacterCollectionViewCell
        
        if isState {
            guard let searchCharacter = presenter.searchCharacter?[indexPath.item] else {
                return UICollectionViewCell() }
            cell.fill(item: SearchCharactersViewModel(searchCharacter))
        } else {
            guard let character = presenter.charactersList?[indexPath.item] else { return UICollectionViewCell() }
            cell.fill(item: CharactersCellViewModel(character))
        }
        
        cell.delegate = self
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 0.2
        cell.layer.cornerRadius = 13
        return cell
    }
    
    // Paginations draging
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height * 0.95 {
            if !hasNextPage { return }
            lastOffset += 1
            presenter.characterFirstLoad(at: lastOffset)
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if(velocity.y > 0) {
            navigationController?.navigationBar.fade()
            tabBarController?.tabBar.unfade()
        } else {
            navigationController?.navigationBar.unfade()
            tabBarController?.tabBar.fade()

          }
    }
}

// MARK: - SearchControllerDelegate
extension AllCharactersViewController: UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        isState = true
        let text = searchController.searchBar.text ?? ""
        let textwithPercentEscapes = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        presenter.searchCharacters(name: textwithPercentEscapes!)
        view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchViewModelList.removeAll()
        presenter.characterFirstLoad(at: lastOffset)
        DispatchQueue.main.async { [weak self] in
            self?.isState = false
            self?.collectionView.reloadData()
        }
    }
}

extension AllCharactersViewController: CharacterViewInput {
    
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
    }
    
    func showAlert() {
        showConnectionAlert()
    }
}

extension AllCharactersViewController: CharacterCellDelegat {
    func infoStateDelegate(name: String, state: Bool) {
    }
}
