//
//  CompensationService.swift
//  The Rick And Morty
//
//  Created by user on 30.03.2022.
//

import Moya
import Foundation

class RickAndmortyService {
    let provider = MoyaProvider<RickAndmortyAPI>()
    
    func getCharacters(request: CharacterRequest, completion: @escaping (Result<CharacterResponse, Error>) -> Void) {
        provider.makeSimpleRequest(.characters(request: request), completion: completion)
    }
    
    func getLocations(request: LocationRequest, completion: @escaping (Result<InfoLocation, Error>) -> Void) {
        provider.makeSimpleRequest(.locations(request: request), completion: completion)
    }
    
    func getEpisode(request: EpisodesRequest, completion: @escaping (Result<EpisodeResponse, Error>) -> Void) {
        provider.makeSimpleRequest(.episodes(request: request), completion: completion)
    }
}
