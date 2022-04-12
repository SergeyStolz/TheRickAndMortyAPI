//
//  ViewController.swift
//  The Rick And Morty
//  Created by user on 30.03.2022.
//

import UIKit
import EasyPeasy
import Alamofire

class AllCharactersViewController: UIViewController {
    
    var presenter: AllCharactersViewOutput!
    
    //MARK: - Private propierties
    private var charactersList: [CharacterResult]? = nil
    private let networkManager = NetworkReachabilityManager()
    internal var searchViewModelList = [SearchCharactersViewModel]()
    private var loadAfterLostConnection = false
    private var hasNextPage = true
    private var isState = false
    private var lastOffset: Int = 1
    
    // MARK: - Private views
    private lazy var detailView: DetailCharacterView = {
        let view = DetailCharacterView()
        return view
    }()
    
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
    
    private lazy var notificationLabel: UILabel = {
        let label = UILabel()
        label.alpha = 0
        label.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.1215686275, alpha: 0.9396283223)
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.layer.masksToBounds = false
        label.layer.cornerRadius = 6
        label.addShadow(
            color: UIColor.green.cgColor,
            shadowRadius: 25,
            shadowOpacity: 1)
        return label
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Characters"
        presenter.startListening()
        collectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        networkManager?.stopListening()
    }
    
    override func viewWillLayoutSubviews() {
        detailView.easy.layout(
            Top(view.frame.size.height/5),
            Bottom(view.frame.size.height/5),
            CenterX(),
            Width(350)
        )
    }
    
    // Setup views functions
    private func setupViews() {
        setupNavBarAndTabBar()
        view.addSubview(searchController.searchBar)
        view.addSubview(collectionView)
        view.addSubview(notificationLabel)
        
        collectionView.easy.layout(
            Edges()
        )
        notificationLabel.easy.layout(
            CenterY(),
            CenterX(),
            Height(113),
            Width(view.frame.size.width-100)
        )
    }
    
    private func setupNavBarAndTabBar() {
        title = "Characters"
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.1215686275, alpha: 0.9396283223)
        tabBarController?.tabBar.barTintColor = #colorLiteral(red: 0.1215686275, green: 0.1215686275, blue: 0.1215686275, alpha: 0.9396283223)
        navigationController?.navigationBar.addShadow(
            color: UIColor.green.cgColor,
            shadowRadius: 0.6,
            shadowOpacity: 0.3
        )
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension AllCharactersViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var characterCount: Int = 0
        if isState {
            characterCount = presenter.searchCharacter?.count ?? 0
        }else {
            characterCount = presenter.charactersList?.count ?? 0
        }
        return characterCount
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CharacterCollectionViewCell.identifier,
            for: indexPath) as! CharacterCollectionViewCell
        
        if isState {
            guard let searchCharacter = presenter.searchCharacter?[indexPath.item] else {
                return UICollectionViewCell() }
            cell.fillSearch(item: SearchCharactersViewModel(searchCharacter))
        } else {
            guard let character = presenter.charactersList?[indexPath.item] else { return UICollectionViewCell() }
            cell.fillCharacter(item: CharactersCellViewModel(character))
        }
        
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 0.2
        cell.layer.cornerRadius = 13
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isState {
            let currentCharacter = presenter.charactersList?[indexPath.item]
            let allCharacters = presenter.charactersList
            let characterDetail = CharacterDetailConfigurator.create(
                currentCharacter: currentCharacter,
                allCharacters: allCharacters)
            self.navigationController?.pushViewController(characterDetail, animated: true)
        } else {
            guard let character = presenter.searchCharacter?[indexPath.row] else { return }
            detailView.character = character
            setupDetailCharacterView()
        }
    }
    
    private func setupDetailCharacterView() {
        view.addSubview(detailView)
        detailView.unfadeScaleTransform()
        searchController.searchBar.searchTextField.resignFirstResponder()
    }
}

// MARK: - ScrollViewDidScroll
extension AllCharactersViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height * 0.95 {
            if !hasNextPage { return }
            lastOffset += 1
            presenter.characterFirstLoad(at: lastOffset)
        }
    }
}

// MARK: - ScrollViewWillEndDragging
extension AllCharactersViewController {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
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
extension AllCharactersViewController: UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        isState = true
        let text = searchController.searchBar.text ?? ""
        let textwithPercentEscapes = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        presenter.searchCharacters(name: textwithPercentEscapes!)
        view.endEditing(true)
    }
}

// MARK: - UISearchResultsUpdating
extension AllCharactersViewController: UISearchResultsUpdating {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchViewModelList.removeAll()
        presenter.characterFirstLoad(at: lastOffset)
        DispatchQueue.main.async { [weak self] in
            self?.isState = false
            self?.collectionView.reloadData()
        }
    }
}

// MARK: - Create Layout
extension AllCharactersViewController {
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
}


// MARK: - CharacterCellDelegat
extension AllCharactersViewController: CharacterCellDelegat {
    func infoStateDelegate(name: String, state: Bool) {
        if state {
            self.notificationLabel.text = "\(name) успешно добавлен в избранное"
            self.notificationLabel.showAnimation()
        } else {
            self.notificationLabel.text = "\(name) удален из избранного"
            self.notificationLabel.showAnimation()
        }
    }
}

// MARK: - AllCharactersViewInput
extension AllCharactersViewController: AllCharactersViewInput {
    func failure(error: Error) {
        print(error.localizedDescription)
    }
    
    func showAlert() {
        showConnectionAlert()
    }
    
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}
