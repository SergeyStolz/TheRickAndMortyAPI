//
//  EpisodesViewController.swift
//  The Rick And Morty
//
//  Created by mac on 05.04.2022.
//

import UIKit
import EasyPeasy

class EpisodesViewController: UIViewController {
    
    var presenter: EpisodesPresenter!
    var episodes: SearchRespondEpisode?
    
    // MARK: - Views
   
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: compositionalLayout
        )
        collectionView.register(
            EpisodCell.self,
            forCellWithReuseIdentifier: EpisodCell.identifier
        )
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
    
    private lazy var fadeView: UIView = {
        let fadeView:UIView = UIView()
        fadeView.frame = self.view.frame
        fadeView.backgroundColor = UIColor.white
        fadeView.alpha = 0.4
        return fadeView
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.easy.layout( Edges() )
        presenter.getEpisodes(isNew: true)
    }
    
    let compositionalLayout: UICollectionViewCompositionalLayout = {
        let fraction: CGFloat = 2.5 / 3.0
        
        // Item
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.8))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(fraction), heightDimension: .fractionalWidth(fraction))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 25, leading: 30, bottom: 0, trailing: 2.5)
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
    
}

extension EpisodesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        guard let charactersName = presenter.episodes?.results[indexPath.row].characters else { return }
        let episodeDetail = DetailEpisodeConfigurator.create(charactersList: charactersName)
        self.navigationController?.pushViewController(episodeDetail, animated: true)
    }
}

extension EpisodesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return presenter.episodes?.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: EpisodCell.identifier,
            for: indexPath) as! EpisodCell
        
        let episodes = presenter.episodes?.results[indexPath.item]
        cell.configure(label: "#\(indexPath.item + 1) Episode")
        cell.addShadow(color: UIColor.green.cgColor, shadowRadius: 25, shadowOpacity: 0.7)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let totalCount = presenter.episodes?.info.count ?? 0
        let currentCount = presenter.episodes?.results.count ?? 0
        
        if indexPath.item == currentCount - 1 {
            if currentCount < totalCount {
                presenter.getEpisodes(isNew: false)
            }
        }
    }
}

extension EpisodesViewController: EpisodesViewInput {
    
    func setupActivityView() {
        view.addSubview(fadeView)
        view.addSubview(activityView)
        activityView.easy.layout(
            CenterX(),
            CenterY()
        )
        activityView.startAnimating()
    }
    
    func removeActivityView() {
        fadeView.removeFromSuperview()
        activityView.stopAnimating()
    }
    
    func succes() {
        collectionView.reloadData()
    }
    func failure(error: Error) {
        print(error.localizedDescription)
    }
}

