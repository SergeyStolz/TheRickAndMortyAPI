//
//  UIViewController+Extensions.swift
//  The Rick And Morty
//
//  Created by user on 31.03.2022.
//

import UIKit

extension UIViewController {
    var lastPresentedViewController: UIViewController? {
        var presented = self.presentedViewController
        while presented?.presentedViewController != nil {
            presented = presented?.presentedViewController
        }
        return presented
    }
}
