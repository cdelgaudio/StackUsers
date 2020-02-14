//
//  MockNetworkManager.swift
//  StackUsers
//
//  Created by Carmine Del Gaudio on 14/02/2020.
//  Copyright © 2020 Carmine Del Gaudio. All rights reserved.
//

import UIKit

class MockNetworkManager: Networkable {
    
    enum TestCase {
        case failure
        case infiniteLoading
        case success
    }
    
    static let testUserResponse: UsersResponse = .init(
    items: [.init(badgeCounts: nil, accountID: 1, isEmployee: nil, lastModifiedDate: nil, lastAccessDate: nil, reputationChangeYear: nil, reputationChangeQuarter: nil, reputationChangeMonth: nil, reputationChangeWeek: nil, reputationChangeDay: nil, reputation: 1, creationDate: nil, userType: nil, userID: 1, acceptRate: nil, location: nil, websiteURL: nil, link: nil, profileImage: "test", displayName: "Test")],
    hasMore: false,
    quotaMax: 0,
    quotaRemaining: 0)
    
    private let test: TestCase
    
    init(test: TestCase) {
        self.test = test
    }
    
    func getImage(
        path: String,
        completion: @escaping NetworkCompletion<Data>
    ) -> URLSessionDownloadTask? {
        switch test {
        case .success:
            completion(.success(#imageLiteral(resourceName: "rss").pngData()!))
        case .failure:
            completion(.failure(.network(description: "Test Error")))
        case .infiniteLoading:
            break
        }
        return nil
    }
    
    func getUsers(
        numberOfUsers: Int,
        completion: @escaping NetworkCompletion<UsersResponse>
    ) -> URLSessionDataTask? {
        switch test {
        case .success:
            completion(.success(MockNetworkManager.testUserResponse))
        case .failure:
            completion(.failure(.network(description: "Test Error")))
        case .infiniteLoading:
            break
        }
        return nil
    }
}
