//
//  UserListTest.swift
//  StackUsersTests
//
//  Created by Carmine Del Gaudio on 14/02/2020.
//  Copyright © 2020 Carmine Del Gaudio. All rights reserved.
//

import XCTest
@testable import StackUsers

class UserListTest: XCTestCase {


    func testCallFailure() {
        let network = MockNetworkManager(test: .failure)
        let viewModel = UserListViewModel(network: network)
        viewModel.start()
        switch viewModel.state.value {
        case .failure:
            XCTAssert(true)
        default:
            XCTAssert(false)
        }
    }
    
    func testCallLoading() {
        let network = MockNetworkManager(test: .infiniteLoading)
        let viewModel = UserListViewModel(network: network)
        viewModel.start()
        switch viewModel.state.value {
        case .loading:
            XCTAssert(true)
        default:
            XCTAssert(false)
        }
    }
    
    func testCallSuccess() {
        let network = MockNetworkManager(test: .success)
        let viewModel = UserListViewModel(network: network)
        viewModel.start()
        switch viewModel.state.value {
        case .loaded:
            XCTAssert(!viewModel.dataSource.isEmpty)
        default:
            XCTAssert(false)
        }
    }
    
    func testCellSelected() {
        let network = MockNetworkManager(test: .success)
        let viewModel = UserListViewModel(network: network)
        viewModel.start()
        viewModel.didSelect(row: 0)
        XCTAssert(viewModel.dataSource.first?.isSelected.value ?? false)
    }
    
    func testUpdated() {
        let network = MockNetworkManager(test: .success)
        let viewModel = UserListViewModel(network: network)
        viewModel.start()
        viewModel.dataSource.first?.blockUser()
        switch viewModel.state.value {
        case .updated:
            XCTAssert(!viewModel.dataSource.isEmpty)
        default:
            XCTAssert(false)
        }
    }

}
