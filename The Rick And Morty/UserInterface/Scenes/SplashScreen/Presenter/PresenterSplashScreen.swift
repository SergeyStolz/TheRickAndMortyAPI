//
//  PresenterSplashScreen.swift
//  The Rick And Morty
//
//  Created by mac on 05.04.2022.
//

import UIKit

class PresenterSplashScreen: SplashScreenViewOutput {
    var view: SplashScreenViewController!
    let networkService = NetworkServiceCharacter()
    
    func loadInitialCharacters() {
        let urlString = "https://rickandmortyapi.com/api/character/?page=1"
        networkService.getCharacters(urlString: urlString) { [weak self] result in
            guard let self = self else { return }
            self.view.removeActivityView()
            DispatchQueue.main.async {
                switch result {
                case .success(let characters):
                    self.view?.succes(characters: characters)
                case .failure(let error):
                    self.view?.failure(error: error)
                }
            }
        }
    }
}
