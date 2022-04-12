//
//  EpisodesViewController.swift
//  The Rick And Morty
//
//  Created by mac on 05.04.2022.
//

import UIKit
import EasyPeasy
import Alamofire

class EpisodesViewController: UIViewController {
    
    // MARK: - Propierties
    var presenter: EpisodesViewOutput!
    private var episodes: [EpisodeResult]? = nil
    private let networkManager = NetworkReachabilityManager()
    private var loadAfterLostConnection = false
    private var lastOffset: Int = 1
    private var hasNextPage = true
    
    // MARK: - Views
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: EpisodesViewController.createLayout()
        )
        collectionView.register(
            EpisodCell.self,
            forCellWithReuseIdentifier: EpisodCell.identifier
        )
        collectionView.contentInset = .init(top: 25, left: 3, bottom: 0, right: 0)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = #colorLiteral(red: 0.1215521768, green: 0.1215801314, blue: 0.1215485111, alpha: 0.9396283223)
        return collectionView
    }()
    
    private lazy var activityView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.hidesWhenStopped = true
        activityView.center = self.view.center
        return activityView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarAndTabBar()
        view.addSubview(collectionView)
        collectionView.easy.layout( Edges() )
        presenter.episodeFirstLoad(at: lastOffset)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Episodes"
        presenter.startListening()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        networkManager?.stopListening()
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

// MARK: - CreateLayout
extension EpisodesViewController {
    static func createLayout() -> UICollectionViewCompositionalLayout {
        let fraction: CGFloat = 2.5 / 3.0
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1.8)
        )
        let item = NSCollectionLayoutItem(
            layoutSize: itemSize
        )
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(fraction),
            heightDimension: .fractionalWidth(fraction)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 25,
            leading: 30,
            bottom: 0,
            trailing: 2.5
        )
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
    }
}

// MARK: - UICollectionViewDelegate
extension EpisodesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let charactersName = presenter.episodes?[indexPath.row].characters else { return }
        let episodeDetail = DetailEpisodeConfigurator.create(charactersList: charactersName)
        self.navigationController?.pushViewController(episodeDetail, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension EpisodesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.episodes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EpisodCell.identifier,
                                                      for: indexPath) as! EpisodCell
        
        cell.configure(label: "#\(indexPath.item + 1) Episode")
        cell.addShadow(color: UIColor.green.cgColor, shadowRadius: 25, shadowOpacity: 0.7)
        return cell
    }
}

// MARK: - ScrollViewDidScroll
extension EpisodesViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height * 0.95 {
            if !hasNextPage { return }
            lastOffset += 1
            presenter.episodeFirstLoad(at: lastOffset)
        }
    }
}

// MARK: - EpisodesViewInput
extension EpisodesViewController: EpisodesViewInput {
    func succes() {
        collectionView.reloadData()
    }
    func failure(error: Error) {
        print(error.localizedDescription)
    }
    
    func showAlert() {
        showConnectionAlert()
    }
}

