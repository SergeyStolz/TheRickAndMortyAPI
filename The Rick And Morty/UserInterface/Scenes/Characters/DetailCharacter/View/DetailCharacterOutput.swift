//
//  DetailCharacterOutput.swift
//  The Rick And Morty
//
//  Created by mac on 05.04.2022.
//


import Foundation

protocol DetailCharacterOutput {
    var data: ResultsCharacter! { get set }
    func showItem()
    func getCharacters()
    var characters: SearchResponseCharacters? { get set }
}
