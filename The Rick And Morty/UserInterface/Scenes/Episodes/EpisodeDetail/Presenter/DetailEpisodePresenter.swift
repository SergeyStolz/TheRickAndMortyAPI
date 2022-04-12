//
//  DetailEpisodePresenter.swift
//  The Rick And Morty
//
//  Created by mac on 05.04.2022.
//

import Foundation

class DetailEpisodePresenter: DetailEpisodeViewOutput {
    func updateBetsCollectionView(model: [CharacterResult]) {
    }
    
    var view: DetailEpisodeViewController?
    var characters: CharacterResult?
    let networkService = NetworkEpisodeDetailCharacter()
    var characterList = [String?]()
    var viewModel = [CharacterResult]()
    
    func getEpisodes() {
        for url in characterList {
            networkService.getCharacters(url: url ?? "") { [weak self] (result) in
                switch result {
                case .success(let characters):
                    _ = [characters]
                    self?.characters = characters
                    self?.viewModel.append(characters!)
                    self?.view?.updateCollectionView(model: self!.viewModel)
                    self?.view?.succes()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
