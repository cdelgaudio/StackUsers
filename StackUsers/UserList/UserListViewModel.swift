//
//  UserListViewModel.swift
//  StackUsers
//
//  Created by Carmine Del Gaudio on 12/02/2020.
//  Copyright © 2020 Carmine Del Gaudio. All rights reserved.
//

import Foundation

class UserListViewModel {
    
    enum State {
        case loading
        case failure         // for demo reasons I'm not going to handle different kind of errors
        case loaded(list: [UsersResponse.Item])
    }
    
    let state: Box<State>
    
    private let network: NetworkManager
    
    private let numberOfUsers: Int = 20
    
    init(network: NetworkManager) {
        self.network = network
        state = .init(.failure)
    }
    
    func start() {
        callGetUsers()
    }
    
    private func callGetUsers() {
        state.value = .loading
        network.getUsers(numberOfUsers: numberOfUsers) { [weak self] result in
            switch result {
            case .success(let response):
                self?.state.value = .loaded(list: response.items)
            case .failure:
                self?.state.value = .failure
            }
        }
    }
}
