//
//  EpisodesViewInput.swift
//  The Rick And Morty
//
//  Created by mac on 05.04.2022.
//

import Foundation

protocol EpisodesViewInput {
    func succes()
    func failure(error: Error)
    func setupActivityView()
    func removeActivityView()
}
