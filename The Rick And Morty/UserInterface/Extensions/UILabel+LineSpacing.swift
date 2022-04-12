//
//  UILabel.swift
//  The Rick And Morty
//
//  Created by mac on 11.04.2022.
//

import UIKit

extension UILabel {
    func setLineSpacing(lineSpacing: CGFloat,
                        lineHeightMultiple: CGFloat,
                        characterSpacing: CGFloat) {
        
        guard let labelText = self.text else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        attributedString.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value:paragraphStyle,
            range:NSMakeRange(0, attributedString.length)
        )
        attributedString.addAttribute(
            NSAttributedString.Key.kern,
            value: characterSpacing,
            range: NSMakeRange(0, attributedString.length)
        )
        self.attributedText = attributedString
    }
}

