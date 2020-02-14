//
//  UserListViewModel.swift
//  StackUsers
//
//  Created by Carmine Del Gaudio on 12/02/2020.
//  Copyright © 2020 Carmine Del Gaudio. All rights reserved.
//

import Foundation

protocol UserListViewModelDelegate: class {
    func updateList()
}

class UserListViewModel {
    
    enum State {
        case loading
        case failure         // for demo reasons I'm not going to handle different kind of errors
        case loaded
        case updated
    }
    
    let state: Bindable<State>
    
    private (set) var dataSource: [UserCellViewModel]
    
    private let network: NetworkManager
    
    private let numberOfUsers: Int = 20
    
    init(network: NetworkManager) {
        self.network = network
        state = .init(.failure)
        dataSource = []
    }
    
    func start() {
        callGetUsers()
    }
    
    // I prefered don't save the selection in the viewController
    func didSelect(row: Int) {
        let selected = dataSource.enumerated().first { $0.element.isSelected.value }
        selected?.element.isSelected.value = false
        let newSelection = dataSource[row]
        if selected?.offset != row, newSelection.userState.value != .blocked {
            newSelection.isSelected.value = true
        }
        state.value = .updated
    }
    
    private func callGetUsers() {
        state.value = .loading
        network.getUsers(numberOfUsers: numberOfUsers) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.dataSource = response.items.map {
                    UserCellViewModel($0, delegate: self, networkManager: self.network)
                }
                self.state.value = .loaded
            case .failure:
                self.state.value = .failure
            }
        }
    }
}

extension UserListViewModel: UserListViewModelDelegate {
    func updateList() {
        state.value = .updated
    }
}
