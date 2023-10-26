//
//  EpisodesPresenter.swift
//  The Rick And Morty
//
//  Created by mac on 05.04.2022.
//

import UIKit
import Alamofire

class EpisodesPresenter: EpisodesViewOutput {
    
    // MARK: - Propierties
    var view: EpisodesViewController?
    var episodes: [EpisodeResult]? = nil
    let networkService = RickAndmortyService()
    let networkManager = NetworkReachabilityManager()
    private var loadAfterLostConnection = false
    private var lastOffset: Int = 1
    private var hasNextPage = true
    
    // MARK: - EpisodeFirstLoad
    func episodeFirstLoad(at: Int) {
        RickAndmortyService().getEpisode(request: EpisodesRequest(name: nil, page: at)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let episodesList):
                if at == 1 {
                    self.episodes = episodesList.results
                } else {
                    self.episodes?.append(contentsOf: episodesList.results)
                }
                DispatchQueue.main.async {
                    self.view?.succes()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - StartListening
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
                    self.episodeFirstLoad(at: self.lastOffset)
                }
            }
        })
    }
    
    // MARK: - LoadCharacters
    func loadCharacters(request: EpisodesRequest, completionHendler: @escaping(Result<[EpisodeResult], Error>) -> Void) {
        RickAndmortyService().getEpisode(request: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let episodesList):
                self.hasNextPage = episodesList.info.next != nil
                completionHendler(.success(episodesList.results))
                self.view?.succes()
            case .failure(let error):
                print(error)
            }
        }
    }
}
