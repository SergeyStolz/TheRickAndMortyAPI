//
//  UINavigationBar+Shadow.swift
//  The Rick And Morty
//
//  Created by mac on 05.04.2022.
//

import UIKit

extension UINavigationBar {
    
}

// MARK: Constants
extension UINavigationBar {
    
    func showNavigationBarShadow() {
        let navigationBarLayer = self.layer
        
        guard navigationBarLayer.shadowOpacity == 0 else {
            return
        }
        
        let shadowOpacityAnimation = CABasicAnimation(
            keyPath: Constants.shadowOpacityAnimationKey)
        shadowOpacityAnimation.fromValue = 0.0
        shadowOpacityAnimation.toValue = Constants.shadowOpacity
        shadowOpacityAnimation.duration = Constants.duration
        navigationBarLayer.add(
            shadowOpacityAnimation,
            forKey: Constants.shadowOffsetAnimationKey)
        navigationBarLayer.shadowColor = Constants.shadowColor.cgColor
        navigationBarLayer.shadowOffset = Constants.shadowOffset
        navigationBarLayer.shadowOpacity = Constants.shadowOpacity
        navigationBarLayer.shadowRadius = Constants.shadowRadius
    }
    
    func hideNavigationBarShadow() {
        let navigationBarLayer = self.layer
        
        guard navigationBarLayer.shadowOpacity > 0 else {
            return
        }
        
        let shadowOpacityAnimation = CABasicAnimation(
            keyPath: Constants.shadowOpacityAnimationKey)
        shadowOpacityAnimation.fromValue = Constants.shadowOpacity
        shadowOpacityAnimation.toValue = 0.0
        shadowOpacityAnimation.duration = Constants.duration
        
        navigationBarLayer.add(shadowOpacityAnimation,
                               forKey: Constants.shadowOffsetAnimationKey)
        navigationBarLayer.shadowOpacity = 0
    }
    
    enum Constants {
        static let duration: TimeInterval = 0.15
        static let shadowOffset: CGSize = CGSize(width: 0, height: 0)
        static let shadowOpacity: Float = 0.12
        static let shadowRadius: CGFloat = 5.0
        static let shadowColor: UIColor = .black
        static let offsetToShowShadow: CGFloat = 0.0
        static let offsetToHideShadow: CGFloat = 10.0
        static let shadowOffsetAnimationKey = "shadowOffsetAnimationKey"
        static let shadowOpacityAnimationKey = "shadowOpacity"
    }
}
