//
//  ViewController.swift
//  StackUsers
//
//  Created by Carmine Del Gaudio on 12/02/2020.
//  Copyright © 2020 Carmine Del Gaudio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        let imageView = UIImageView()
        view.addSubview(imageView)
        imageView.autoPinToSuperview()
        
        NetworkManager.shared.getUsers(numberOfUsers: 20) { result in
            switch result {
            case .success(let response):
                let imageUrl = response.items.first?.profileImage ?? ""
                NetworkManager.shared.getImage(path: imageUrl) { result in
                    switch result {
                    case .success(let data):
                        let image = UIImage(data: data)
                        DispatchQueue.main.async {
                            imageView.image = image
                        }
                    case .failure:
                        break
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

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
