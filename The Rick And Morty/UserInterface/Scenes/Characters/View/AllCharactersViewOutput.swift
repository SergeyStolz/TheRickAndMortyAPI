//
//  CharacterViewOutput.swift
//  The Rick And Morty
//
//  Created by mac on 04.04.2022.
//

import UIKit

protocol AllCharactersViewOutput {
    var charactersList: [CharacterResult]? { get set }
    var searchCharacter: [CharacterResult]? { get set }
    func startListening()
    func characterFirstLoad(at: Int)
    func searchCharacters(name: String)
    func loadCharacters(request: CharacterRequest, completionHendler: @escaping(Result<[CharacterResult], Error>) -> Void)
}
