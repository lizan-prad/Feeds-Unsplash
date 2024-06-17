//
//  UIView+Extensions.swift
//  TeletronincsAssessment
//
//  Created by Lizan on 15/06/2024.
//

import UIKit

extension String {
    
    func formattedToStandard() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = formatter.date(from: self)
        formatter.dateFormat = "yyyy MMM dd"
        return formatter.string(from: date ?? Date())
    }
}

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
