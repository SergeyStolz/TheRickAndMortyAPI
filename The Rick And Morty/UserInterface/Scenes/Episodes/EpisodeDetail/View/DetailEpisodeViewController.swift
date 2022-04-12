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
    var viewModel = [CharacterResult]()
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
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        presenter.getEpisodes()
        collectionView.easy.layout( Edges() )
        setupNavigationController()
     }
    
    private func setupNavigationController() {
        title = "Episode characters"
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        navigationBar.topItem!.title = ""
        navigationBar.tintColor = UIColor.green
        let navController = UINavigationController()
        navController.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.font: UIFont.init(name: "Hoefler Text", size: 25)!]
    }
}

// MARK: - UICollectionViewDataSource
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

// MARK: - DetailEpisodeViewInput
extension DetailEpisodeViewController: DetailEpisodeViewInput {
    func succes() {
        collectionView.reloadData()
    }
    
    func failure(error: Error) {
        print(error.localizedDescription)
    }
    func updateCollectionView(model: [CharacterResult]) {
        viewModel = model
        collectionView.reloadData()
    }
}
