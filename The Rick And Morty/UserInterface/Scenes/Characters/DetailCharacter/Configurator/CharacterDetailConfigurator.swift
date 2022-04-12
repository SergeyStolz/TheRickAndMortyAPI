//
//  CharacterDetailConfigurator.swift
//  The Rick And Morty
//
//  Created by mac on 05.04.2022.
//

import Foundation

import UIKit

class CharacterDetailConfigurator {
    
    static func create(currentCharacter: CharacterResult?, allCharacters: [CharacterResult]?) -> UIViewController {
        let view = DetailCharacterViewController()
        let presenter = DetailCharacterPresenter()
        presenter.currentCharacter = currentCharacter
        presenter.allCharacters = allCharacters
        view.presenter = presenter
        presenter.view = view
        return view
    }
}
