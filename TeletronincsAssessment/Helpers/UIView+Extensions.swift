//
//  UIView+Extensions.swift
//  TeletronincsAssessment
//
//  Created by Lizan on 15/06/2024.
//

import UIKit

extension UIView {
    
    // method to add corner radius to a view
    func addCornerRadius(_ value: CGFloat) {
        self.layer.cornerRadius = value
    }
    
    // method to add shadow effect with corner radius to a view
    func addShadowAndCorner(radius: CGFloat, shadowOpacity: Float = 0.3, shadowRadius: CGFloat = 3.0, shadowOffset: CGSize = CGSize(width: 0, height: 2)) {
        layer.cornerRadius = radius
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.shadowOffset = shadowOffset
    }
}
