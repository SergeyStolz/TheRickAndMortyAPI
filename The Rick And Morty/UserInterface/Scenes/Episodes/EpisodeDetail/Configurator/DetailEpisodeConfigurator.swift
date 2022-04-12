//
//  DetailEpisodeConfigurator.swift
//  The Rick And Morty
//
//  Created by mac on 05.04.2022.
//

import UIKit

class DetailEpisodeConfigurator {
    
    static func create(charactersList: [String]) -> UIViewController {
        let view = DetailEpisodeViewController()
        let presenter = DetailEpisodePresenter()
        presenter.characterList = charactersList
        view.presenter = presenter
        presenter.view = view
        return view
    }
}

