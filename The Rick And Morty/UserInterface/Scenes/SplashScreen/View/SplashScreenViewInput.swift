//
//  SplashScreenViewInput.swift
//  The Rick And Morty
//
//  Created by mac on 05.04.2022.
//

import Foundation

protocol SplashScreenViewInput {
    func failure(error: Error)
    func succes(characters: [CharacterResult]?)
    func startActivityView()
    func stopActivityView()
    func removeActivityView()
}
