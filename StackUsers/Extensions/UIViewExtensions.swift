//
//  UIViewExtensions.swift
//  StackUsers
//
//  Created by Carmine Del Gaudio on 12/02/2020.
//  Copyright © 2020 Carmine Del Gaudio. All rights reserved.
//

import UIKit

extension UIView {
    func autoPinToSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        guard let superview = superview else {
            print("impossible to set the constraint, missing superview")
            return
        }
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            leftAnchor.constraint(equalTo: superview.leftAnchor),
            rightAnchor.constraint(equalTo: superview.rightAnchor)
            ]
        )
    }
}
