//
//  ServerConstants.swift
//  The Rick And Morty
//
//  Created by user on 30.03.2022.
//

import Foundation

enum ServerConstants {
    static let baseUrl = URL(string: "https://rickandmortyapi.com/api")!
    static let requestHeader: [String: String] = [
        "Content-Type": "application/json"
    ]
    static let cookieName = ".rickAndMortyApi"
}
