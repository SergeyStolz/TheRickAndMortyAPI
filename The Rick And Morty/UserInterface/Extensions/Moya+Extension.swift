//
//  Moya+Extension.swift
//  The Rick And Morty
//
//  Created by user on 30.03.2022.
//

import Foundation
import Moya

extension Notification.Name {
    static let unauthorizedDidReceive = Notification.Name(rawValue: "unauthorizedDidReceive")
}

extension MoyaProviderType {
    @discardableResult
    func makeSimpleRequest<D: Decodable>(_ target: Target, callbackQueue: DispatchQueue? = .none, progress: Moya.ProgressBlock? = .none, completion: @escaping (Result<D, Error>) -> Void) -> Cancellable {
        
        self.request(target, callbackQueue: callbackQueue, progress: progress) { result in
            switch result {
            case .success(let response):
                do {
                    let res = try response.map(D.self)
                    completion(.success(res))
                } catch let mappingError {
                    completion(.failure(mappingError))
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
