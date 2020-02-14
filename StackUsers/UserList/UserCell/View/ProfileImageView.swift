//
//  ProfileImageView.swift
//  StackUsers
//
//  Created by Carmine Del Gaudio on 14/02/2020.
//  Copyright © 2020 Carmine Del Gaudio. All rights reserved.
//

import UIKit

class ProfileView: UIView {
    
    private let loadingView: UIActivityIndicatorView
    private let imageView: UIImageView
    
    var image: UIImage? {
        didSet {
            imageView.image = image
            backgroundColor = image == nil ? .lightGray : .clear
        }
    }
    
    init() {
        loadingView = .init(style: .medium)
        loadingView.hidesWhenStopped = true
        imageView = .init(image: nil)
        super.init(frame: .zero)
        clipsToBounds = true
        layer.cornerRadius = 35
        layer.borderColor = UIColor.darkWhite.cgColor
        layer.borderWidth = 1
        backgroundColor = .lightGray
        
        addSubview(imageView)
        addSubview(loadingView)
        imageView.autoPinToSuperview()
        loadingView.autoPinToSuperview()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func startLoading() {
        loadingView.startAnimating()
    }
    
    func stopLoading() {
        loadingView.stopAnimating()
    }
}
