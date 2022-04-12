//
//  CharacterDetailConfigurator.swift
//  The Rick And Morty
//
//  Created by mac on 05.04.2022.
//

import Foundation

import UIKit

class CharacterDetailConfigurator {
    
    static func create(data: ResultsCharacter?) -> UIViewController {
        let view = DetailCharacterViewController()
        let presenter = DetailCharacterPresenter()
        presenter.data = data
        view.presenter = presenter
        presenter.view = view
        return view
    }
}
