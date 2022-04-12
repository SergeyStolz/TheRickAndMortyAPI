//
//  FavoritesConfigurator.swift
//  The Rick And Morty
//
//  Created by mac on 04.04.2022.
//

import UIKit

class FavoritesConfigurator {
    static func create() -> UIViewController {
        let view = FavoritesViewController()
        let presenter = FavoritesPresenter()
        view.presenter = presenter
        presenter.view = view
        return view
    }
}
