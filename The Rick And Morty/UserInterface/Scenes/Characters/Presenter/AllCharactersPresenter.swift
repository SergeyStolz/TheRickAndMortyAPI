//
//  CharactersPresenter.swift
//  The Rick And Morty
//
//  Created by mac on 04.04.2022.
//

import UIKit
import RealmSwift
import Alamofire

class AllCharactersPresenter: CharacterViewOutput {
    var view: AllCharactersViewController?
    var charactersList: [CharacterResult]? = nil
    var searchCharacter: [CharacterResult]? = nil
    let networkService = RickAndmortyService()
    let networkManager = NetworkReachabilityManager()
    private var loadAfterLostConnection = false
    private var lastOffset: Int = 1
    private var hasNextPage = true
    
    // MARK: - Private properties
    private var isRequestLocked = false
    private var searching = false
   
    
    func characterFirstLoad(at: Int) {
        RickAndmortyService().getCharacters(request: CharacterRequest(name: nil, page: at)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let charactersList):
                if at == 1 {
                    self.charactersList = charactersList.results
                } else {
                    self.charactersList?.append(contentsOf: charactersList.results)
                }
                DispatchQueue.main.async {
                    self.view?.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func startListening() {
        networkManager?.startListening(onUpdatePerforming: { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .unknown:
                break
            case .notReachable:
                self.loadAfterLostConnection.toggle()
                self.view?.showAlert()
            case .reachable(_):
                if self.loadAfterLostConnection {
                    self.loadAfterLostConnection.toggle()
                    self.lastOffset = 1
                    self.characterFirstLoad(at: self.lastOffset)
                }
            }
        })
    }
    
    func loadCharacters(request: CharacterRequest, completionHendler: @escaping(Result<[CharacterResult], Error>) -> Void) {
        RickAndmortyService().getCharacters(request: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let character):
                self.hasNextPage = character.info.next != nil
                completionHendler(.success(character.results))
                self.view?.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func searchCharacters(name: String) {
        let request = CharacterRequest(name: name, page: nil)
        RickAndmortyService().getCharacters(request: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let character):
                self.searchCharacter = character.results
                self.view?.reloadData()
            case .failure(let error):
                print(error)
            }
        }
}
}
