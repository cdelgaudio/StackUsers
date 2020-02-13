//
//  Extensions.swift
//  StackUsers
//
//  Created by Carmine Del Gaudio on 12/02/2020.
//  Copyright © 2020 Carmine Del Gaudio. All rights reserved.
//

import UIKit

extension UIView {
    enum Anchor {
        case top, left, right, bottom, none
    }
    
    func autoPinToSuperview(excluding: [Anchor] = []) {
        translatesAutoresizingMaskIntoConstraints = false
        guard let superview = superview else {
            print("impossible to set the constraint, missing superview")
            return
        }
        NSLayoutConstraint.activate([
            excluding.contains(.top) ? nil : topAnchor.constraint(equalTo: superview.topAnchor),
            excluding.contains(.bottom) ? nil : bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            excluding.contains(.left) ? nil : leftAnchor.constraint(equalTo: superview.leftAnchor),
            excluding.contains(.right) ? nil : rightAnchor.constraint(equalTo: superview.rightAnchor)
            ].compactMap { $0 }
        )
    }
    
    func autoPinDimensions(size: CGSize) {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: size.height),
            widthAnchor.constraint(equalToConstant: size.width)
            ]
        )
    }
}

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        self.clipsToBounds = true
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: forState)
        }
    }
}


extension UIView {
    static func spacer(height: CGFloat) -> UIView {
        let newView = UIView()
        newView.heightAnchor.constraint(equalToConstant: height).isActive = true
        return newView
    }
    
    static func spacer(widht: CGFloat) -> UIView {
        let newView = UIView()
        newView.widthAnchor.constraint(equalToConstant: widht).isActive = true
        return newView
    }
    
    static func flexibleSpacer() -> UIView {
        UIView()
    }
}

extension UIColor {
    static let darkGreen: UIColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
    static let darkWhite: UIColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
}


extension UITableViewCell {
    static let identifier: String = String(describing: self)
}
