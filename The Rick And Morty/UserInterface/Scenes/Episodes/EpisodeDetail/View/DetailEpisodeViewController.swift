//
//  DetailEpisodeViewController.swift
//  The Rick And Morty
//
//  Created by mac on 05.04.2022.
//

import UIKit
import EasyPeasy

class DetailEpisodeViewController: UIViewController {
    var presenter: DetailEpisodePresenter!
    var viewModel = [SearchRespondEpisodCharacter]()
    let detailView = DetailCharacterView()
    
    // MARK: - Views
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(EpisodeDetailCell.self,
                                forCellWithReuseIdentifier: EpisodeDetailCell.identifier)
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width / 3 - 1,
                                 height: view.frame.size.width / 3 - 1)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 2
        
        return layout
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
        presenter.getEpisodes()
        setupNavigationController()
     }
    
    private func setupNavigationController() {
        title = "Episode characters"
        guard let navigationBar = self.navigationController?.navigationBar else { return }
//        title = presenter.data.name
        navigationBar.topItem!.title = ""
        navigationBar.tintColor = UIColor.green
        
        
        let navController = UINavigationController()
        navController.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.font: UIFont.init(name: "Hoefler Text", size: 25)!]
    }
}

extension DetailEpisodeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EpisodeDetailCell.identifier, for: indexPath) as! EpisodeDetailCell
        
        cell.fill(item: viewModel[indexPath.item])
        return cell
    }
}

extension DetailEpisodeViewController: DetailEpisodeViewInput {
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
    func updateBetsCollectionView(model: [SearchRespondEpisodCharacter]) {
        viewModel = model
        collectionView.reloadData()
    }
}
