//
//  UIApplication+Extension.swift
//  The Rick And Morty
//
//  Created by mac on 08.04.2022.
//

import UIKit

extension UIApplication {
    static var rootViewController: UIViewController? {
        get { shared.keyWindow?.rootViewController }
        set { shared.keyWindow?.rootViewController = newValue }
    }
}
