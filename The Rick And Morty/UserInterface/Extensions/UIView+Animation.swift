//
//  UIView+Animation.swift
//  The Rick And Morty
//
//  Created by mac on 05.04.2022.
//

import UIKit

// MARK: Layout animations
extension UIView {
    func layoutSubviewsAnimated(duration: Double = Constants.defaultLayoutDuration) {
        UIView.animate(withDuration: duration, animations: {
            self.layoutIfNeeded()
        })
    }
    
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.speed = 2.5
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    func stopRotate() {
        layer.removeAllAnimations()
    }
}

// MARK: Fading animations
extension UIView {
    func fade(duration: TimeInterval = Constants.defaultFadeDuration) {
        guard !isHidden else { return }
        
        let animations = {
            self.alpha = Constants.fadedAlpha
        }
        
        let completion = { (completed: Bool) in
            self.isHidden = true
            self.alpha = Constants.unfadedAlpha
        }
        
        UIView.animate(withDuration: duration, animations: animations, completion: completion)
    }
    
    func unfade(duration: TimeInterval = Constants.defaultFadeDuration) {
        guard isHidden else { return }
        
        let animations = {
            self.alpha = Constants.unfadedAlpha
        }
        
        alpha = Constants.fadedAlpha
        isHidden = false
        UIView.animate(withDuration: duration, animations: animations)
    }
}

// MARK: Constants
private extension UIView {
    enum Constants {
        static let defaultFadeDuration: TimeInterval = 0.25
        static let defaultLayoutDuration: TimeInterval = 0.25
        static let fadedAlpha: CGFloat = 0.0
        static let unfadedAlpha: CGFloat = 1.0
    }
}
