//
//  CharactersConfigurator.swift
//  The Rick And Morty
//
//  Created by mac on 04.04.2022.
//
import UIKit

class CharactersConfigurator {
    static func create(characters: [CharacterResult]?) -> UIViewController {
        let view = AllCharactersViewController()
        let presenter = AllCharactersPresenter()
        presenter.charactersList = characters
        view.presenter = presenter
        presenter.view = view
        return view
    }
}
