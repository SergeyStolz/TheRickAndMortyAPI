//
//  EpisodesConfigurator.swift
//  The Rick And Morty
//
//  Created by mac on 05.04.2022.
//

import UIKit

class EpisodesConfigurator {
    static func create() -> UIViewController {
        let view = EpisodesViewController()
        let presenter = EpisodesPresenter()
        view.presenter = presenter
        presenter.view = view
        return view
    }
}

