//
//  UIView+Time Animations.swift
//  The Rick And Morty
//
//  Created by mac on 06.04.2022.
//

import UIKit

extension UIView {
    func showAnimation() {
        UIView.animate(withDuration: 1.0,
                       delay: 0.1,
                       options: .curveEaseOut,
                       animations: {
            self.alpha = 1
        },
                       completion: { finished in
            UIView.animate(withDuration: 0.3,
                           delay: 0.8, animations: {
                self.alpha = 0
            })
        })
    }
}
