//
//  EpisodeResponse.swift
//  The Rick And Morty
//
//  Created by user on 30.03.2022.
//

import Foundation

// MARK: - EpisodeResponse
struct EpisodeResponse: Codable {
    let info: InfoEpisode
    let results: [EpisodeResult]
}

// MARK: - InfoEpisode
struct InfoEpisode: Codable {
    let count: Int?
    let pages: Int?
    let next: String?
    let prev: String?
}

// MARK: - EpisodeResult
struct EpisodeResult: Codable {
    let id: Int?
    let name: String?
    let air_date: String?
    let episode: String?
    let characters: [String]?
    let url: String?
    let created: String?
}

