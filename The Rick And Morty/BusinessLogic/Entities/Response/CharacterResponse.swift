//
//  CharacterResponse.swift
//  The Rick And Morty
//
//  Created by user on 30.03.2022.
//

import Foundation

// MARK: - CharacterResponse
struct CharacterResponse: Codable {
    let info: InfoCharacter
    let results: [CharacterResult]
}

// MARK: - InfoCharacter
struct InfoCharacter: Codable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

// MARK: - CharacterResult
struct CharacterResult: Codable, DetailCharacterProtocol {
    var image: String
    
    var name: String
    
    var status: String
    
    var species: String
    
    var type: String
    
    var gender: String
    
    var id: Int
    
    let origin: Location
    let location: Location
    let episode: [String]
    let url: String
    let created: String
}

// MARK: - Location
struct Location: Codable {
    let name: String
    let url: String
}
