//
//  RickAndmortyApi.swift
//  The Rick And Morty
//
//  Created by user on 30.03.2022.
//

import Moya
import Foundation

enum RickAndmortyAPI {
    case characters(request: CharacterRequest)
    case locations(request: LocationRequest)
    case episodes(request: EpisodesRequest)
}

extension RickAndmortyAPI: TargetType {
    var baseURL: URL {
        return ServerConstants.baseUrl
    }
    
    var path: String {
        switch self {
        case .characters:
            return "/character"
        case .locations:
            return "/location"
        case .episodes:
            return "/episode"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .characters:
            return .get
        case .locations:
            return .get
        case .episodes:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .characters(let request):
            let dict = request.toDict()
            return .requestParameters(parameters: dict, encoding: URLEncoding.queryString)
            
        case .locations(let request):
            let dict = request.toDict()
            return .requestParameters(parameters: dict, encoding: URLEncoding.queryString)
            
        case .episodes(let request):
            let dict = request.toDict()
            return .requestParameters(parameters: dict, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        var headers = ServerConstants.requestHeader
        headers["Content-Type"] = "application/json"
        return headers
    }
    
    var sampleData: Data {
        return Data()
    }
}
