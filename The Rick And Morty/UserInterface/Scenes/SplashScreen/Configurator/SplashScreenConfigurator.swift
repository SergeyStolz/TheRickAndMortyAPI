//
//  SplashScreenConfigurator.swift
//  The Rick And Morty
//
//  Created by mac on 05.04.2022.
//

import UIKit

class SplashScreenConfigurator {
    static func create() -> UIViewController {
        let view = SplashScreenViewController()
        let presenter = PresenterSplashScreen()
        view.presenter = presenter
        presenter.view = view
        return view
    }
}
