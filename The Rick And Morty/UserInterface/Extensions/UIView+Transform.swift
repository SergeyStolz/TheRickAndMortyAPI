//
//  UIView+Transform.swift
//  The Rick And Morty
//
//  Created by mac on 06.04.2022.
//

import UIKit

extension UIView {
    func unfadeScaleTransform() {
        self.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.alpha = 1
            self.transform = CGAffineTransform.identity
        }
    }
    
    func fadeScaleTransform() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            guard let self = self else { return }
            self.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
            self.alpha = 0
        }) { (success) in
            self.removeFromSuperview()
        }
    }
}
