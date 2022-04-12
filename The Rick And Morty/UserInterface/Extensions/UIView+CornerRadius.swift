//
//  UIViewController + cornerRadius.swift
//  The Rick And Morty
//
//  Created by mac on 04.04.2022.
//

import UIKit

extension UIViewController {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
