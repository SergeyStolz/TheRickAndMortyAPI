//
//  PresenterSplashScreen.swift
//  The Rick And Morty
//
//  Created by mac on 05.04.2022.
//

import UIKit
import Alamofire

class PresenterSplashScreen: SplashScreenViewOutput {
    var view: SplashScreenViewController!
    
    // MARK: - Private propierties
    private var characters: [CharacterResult]? = nil
    private let networkService = RickAndmortyService()
    private let networkManager = NetworkReachabilityManager()
    private var loadAfterLostConnection = false
    private var lastOffset: Int = 1
}

// MARK: - CharacterFirstLoad
extension PresenterSplashScreen {
    func characterFirstLoad(at: Int) {
        view.startActivityView()
        RickAndmortyService().getCharacters(request: CharacterRequest(name: nil, page: at)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let characters):
                self.view?.succes(characters: characters.results)
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - StartListening
extension PresenterSplashScreen {
    func startListening() {
        networkManager?.startListening(onUpdatePerforming: { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .unknown:
                break
            case .notReachable:
                self.loadAfterLostConnection.toggle()
                self.view.startActivityView()
                self.view?.showAlert()
            case .reachable(_):
                if self.loadAfterLostConnection {
                    self.loadAfterLostConnection.toggle()
                    self.lastOffset = 1
                    self.characterFirstLoad(at: self.lastOffset)
                    self.view.stopActivityView()
                }
            }
        })
    }
}
