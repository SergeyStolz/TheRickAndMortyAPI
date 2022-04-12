//
//  DetailCharacterOutput.swift
//  The Rick And Morty
//
//  Created by mac on 05.04.2022.
//


import Foundation

protocol DetailCharacterOutput {
    var allCharacters: [CharacterResult]? { get set }
    var charactersList: [CharacterResult]? { get set }
    var currentCharacter: CharacterResult? { get set }
    func characterFirstLoad(at: Int)
    func startListening()
}
