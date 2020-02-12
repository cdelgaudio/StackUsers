//
//  ViewController.swift
//  StackUsers
//
//  Created by Carmine Del Gaudio on 12/02/2020.
//  Copyright © 2020 Carmine Del Gaudio. All rights reserved.
//

import UIKit

class UserListViewController: UIViewController {

    private let viewModel: UserListViewModel
    
    init(viewModel: UserListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBindings()
        viewModel.start()
    }
    
    private func configureBindings() {
        viewModel.state.bind { state in
            DispatchQueue.main.async { [weak self] in
                self?.stateDidChange(state: state)
            }
        }
    }
    
    private func stateDidChange(state: UserListViewModel.State) {
        switch state {
        case .loading:
            view.backgroundColor = .yellow
        case .failure:
            view.backgroundColor = .red
        case .loaded(let list):
            view.backgroundColor = .white
        }
    }
}
