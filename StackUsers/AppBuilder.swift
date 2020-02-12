//
//  AppBuilder.swift
//  StackUsers
//
//  Created by Carmine Del Gaudio on 12/02/2020.
//  Copyright © 2020 Carmine Del Gaudio. All rights reserved.
//

import UIKit

class AppBuilder {
    func build() -> UIViewController {
        let viewModel = UserListViewModel(network: NetworkManager.shared)
        let controller = UserListViewController(viewModel: viewModel)
        return controller
    }
}
