//
//  DetailCharacterPresenter.swift
//  The Rick And Morty
//
//  Created by mac on 05.04.2022.
//

import Foundation

import UIKit

class DetailCharacterPresenter {
    var view: DetailCharacterViewController!
    var data: ResultsCharacter!
    var allData: ResultsCharacter!
    
    var characters: SearchResponseCharacters?
    let networkService = NetworkServiceCharacter()
        
    func getCharacters() {
            let urlString = "https://rickandmortyapi.com/api/character/?page=1"
            networkService.getCharacters(urlString: urlString) { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success(let characters):
                        self.characters = characters
                        self.view?.succes()
                    case .failure(let error):
                        self.view?.failure(error: error)
                    }
                }
            }
        }
}
