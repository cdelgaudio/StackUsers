//
//  CellButton.swift
//  StackUsers
//
//  Created by Carmine Del Gaudio on 13/02/2020.
//  Copyright © 2020 Carmine Del Gaudio. All rights reserved.
//

import UIKit

class CellButton: UIButton {
    
    init() {
        super.init(frame: .zero)
    }
    
    func configureNormal(title: String, tintColor: UIColor, backgroundColor: UIColor) {
        setTitle(title, for: .normal)
        setTitleColor(tintColor, for: .normal)
        setBackgroundColor(color: backgroundColor, forState: .normal)
        contentEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
        layer.borderColor = tintColor.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 15
    }
    
    func configureSelected(title: String, tintColor: UIColor, backgroundColor: UIColor) {
        setTitle(title, for: .selected)
        setTitleColor(tintColor, for: .selected)
        setBackgroundColor(color: backgroundColor, forState: .selected)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
