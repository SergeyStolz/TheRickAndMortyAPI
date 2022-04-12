//
//  CompensationService.swift
//  The Rick And Morty
//
//  Created by user on 30.03.2022.
//

import Moya
import Foundation

class RickAndmortyService {
    let provaider = MoyaProvider<RickAndmortyAPI>()
    
    func getCharacters(request: ForDeliveryCompensationRequest, completion: @escaping (Result<ForDeliveryCompensationResponse, BringoError>) -> Void) {
        provider.makeRequest(.(request: request), completion: completion)
    }
    
    func getLocations(request: ForDeliveryCompensationRequest, completion: @escaping (Result<ForDeliveryCompensationResponse, BringoError>) -> Void) {
        provider.makeRequest(.forDelivery(request: request), completion: completion)
    }
    
    func getEpisode(request: ForDeliveryCompensationRequest, completion: @escaping (Result<ForDeliveryCompensationResponse, BringoError>) -> Void) {
        provider.makeRequest(.forDelivery(request: request), completion: completion)
    }
}
