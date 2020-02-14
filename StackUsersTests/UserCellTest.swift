//
//  UserCellTest.swift
//  StackUsersTests
//
//  Created by Carmine Del Gaudio on 14/02/2020.
//  Copyright © 2020 Carmine Del Gaudio. All rights reserved.
//

import XCTest
@testable import StackUsers

class UserCellTest: XCTestCase {

    func testCallFailure() {
        let network = MockNetworkManager(test: .failure)
        let listViewModel = UserListViewModel(network: network)
        let cellViewModel = UserCellViewModel(
            MockNetworkManager.testUserResponse.items.first!,
            delegate: listViewModel,
            networkManager: network
        )
        cellViewModel.didAppear()
        switch cellViewModel.imageState.value {
        case .failure:
            XCTAssert(true)
        default:
            XCTAssert(false)
        }
    }
    
    func testCallLoading() {
        let network = MockNetworkManager(test: .infiniteLoading)
        let listViewModel = UserListViewModel(network: network)
        let cellViewModel = UserCellViewModel(
            MockNetworkManager.testUserResponse.items.first!,
            delegate: listViewModel,
            networkManager: network
        )
        cellViewModel.didAppear()
        switch cellViewModel.imageState.value {
        case .loading:
            XCTAssert(true)
        default:
            XCTAssert(false)
        }
    }
    
    func testCallSuccess() {
        let network = MockNetworkManager(test: .success)
        let listViewModel = UserListViewModel(network: network)
        let cellViewModel = UserCellViewModel(
            MockNetworkManager.testUserResponse.items.first!,
            delegate: listViewModel,
            networkManager: network
        )
        cellViewModel.didAppear()
        switch cellViewModel.imageState.value {
        case .loaded:
            XCTAssert(true)
        default:
            XCTAssert(false)
        }
    }
    
    func testName() {
        let network = MockNetworkManager(test: .success)
        let listViewModel = UserListViewModel(network: network)
        let cellViewModel = UserCellViewModel(
            MockNetworkManager.testUserResponse.items.first!,
            delegate: listViewModel,
            networkManager: network
        )
        cellViewModel.didAppear()
        XCTAssert(cellViewModel.name == "Test")
    }
    
    func testReputation() {
        let network = MockNetworkManager(test: .success)
        let listViewModel = UserListViewModel(network: network)
        let cellViewModel = UserCellViewModel(
            MockNetworkManager.testUserResponse.items.first!,
            delegate: listViewModel,
            networkManager: network
        )
        cellViewModel.didAppear()
        XCTAssert(cellViewModel.reputation == "Reputation: 1")
    }
    
    func testFollow() {
        let network = MockNetworkManager(test: .success)
        let listViewModel = UserListViewModel(network: network)
        let cellViewModel = UserCellViewModel(
            MockNetworkManager.testUserResponse.items.first!,
            delegate: listViewModel,
            networkManager: network
        )
        cellViewModel.didAppear()
        cellViewModel.toggleFollow()
       switch cellViewModel.userState.value {
        case .followed:
            XCTAssert(true)
        default:
            XCTAssert(false)
        }
    }
    
    func testUnfollow() {
        let network = MockNetworkManager(test: .success)
        let listViewModel = UserListViewModel(network: network)
        let cellViewModel = UserCellViewModel(
            MockNetworkManager.testUserResponse.items.first!,
            delegate: listViewModel,
            networkManager: network
        )
        cellViewModel.didAppear()
        cellViewModel.toggleFollow()
        cellViewModel.toggleFollow()
       switch cellViewModel.userState.value {
        case .unfollowed:
            XCTAssert(true)
        default:
            XCTAssert(false)
        }
    }
    
    func testBlocked() {
        let network = MockNetworkManager(test: .success)
        let listViewModel = UserListViewModel(network: network)
        let cellViewModel = UserCellViewModel(
            MockNetworkManager.testUserResponse.items.first!,
            delegate: listViewModel,
            networkManager: network
        )
        cellViewModel.didAppear()
        cellViewModel.blockUser()
       switch cellViewModel.userState.value {
        case .blocked:
            XCTAssert(true)
        default:
            XCTAssert(false)
        }
    }
    
}
