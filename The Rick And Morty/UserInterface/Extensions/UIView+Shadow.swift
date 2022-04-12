//
//  UIView+Shadow.swift
//  The Rick And Morty
//
//  Created by mac on 04.04.2022.
//

import UIKit

extension UIView {
    func addShadow(color: CGColor, shadowRadius: CGFloat, shadowOpacity: Float) {
        self.layer.shadowColor = color
        self.layer.shadowOffset = CGSize(width: -1, height: 2)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = shadowOpacity
    }
}
