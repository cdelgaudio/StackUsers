//
//  Box.swift
//  StackUsers
//
//  Created by Carmine Del Gaudio on 12/02/2020.
//  Copyright © 2020 Carmine Del Gaudio. All rights reserved.
//

import Foundation

class Box<T> {
    var value: T {
        didSet {
            callBack?(value)
        }
    }
    
    private var callBack: ((T) -> Void)?
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(callBack: @escaping (T) -> Void) {
        self.callBack = callBack
    }
}
