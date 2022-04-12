//
//  EpisodeDetailCharacterAPi.swift
//  The Rick And Morty
//
//  Created by mac on 05.04.2022.
//

import UIKit

class NetworkEpisodeDetailCharacter {
    func getCharacters(url: String, completion: @escaping (Result<CharacterResult?, Error>) -> Void) {
        let urlString = url
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Some error")
                    completion(.failure(error))
                    return
                }
                guard let data = data else { return }
                do{
                    let detailCharacter = try JSONDecoder().decode(CharacterResult.self, from: data)
                    completion(.success(detailCharacter))
                } catch let jsonError {
                    print("Failed to decode JSON", jsonError)
                    completion(.failure(jsonError))
                }
            }
        }
        .resume()
    }
}
