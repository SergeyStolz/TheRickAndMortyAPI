//
//  LocationResponse.swift
//  The Rick And Morty
//
//  Created by user on 30.03.2022.
//

import Foundation

// MARK: - LocationResponse
struct LocationResponse: Codable {
    let info: InfoLocation
    let results: [LocationResult]
}

// MARK: - InfoLocation
struct InfoLocation: Codable {
    let count: Int
    let pages: Int
    let next: String
    let prev: String
}

// MARK: - LocationResult
struct LocationResult: Codable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    let url: String
    let created: String
}
