//
//  UserCellViewModel.swift
//  StackUsers
//
//  Created by Carmine Del Gaudio on 12/02/2020.
//  Copyright © 2020 Carmine Del Gaudio. All rights reserved.
//

import UIKit

class UserCellViewModel {
    
    enum ImageState {
        case failure
        case loading
        case loaded(image: UIImage)
    }
    
    enum UserState {
        case blocked, followed, unfollowed
    }
    
    var name: String { user.displayName }
    
    var reputation: String { "Reputation: \(user.reputation)" }
    
    var isSelected: Box<Bool>
    
    private (set) var imageState: Box<ImageState>
    
    private (set) var userState: Box<UserState>
    
    private var image: UIImage?
    
    private let user: UsersResponse.Item
    
    private let networkManager: NetworkManager
    
    private unowned let delegate: UserListViewModelDelegate
    
    init(
        _ user: UsersResponse.Item,
        delegate: UserListViewModelDelegate,
        networkManager: NetworkManager)
    {
        self.user = user
        self.networkManager = networkManager
        self.delegate = delegate
        imageState = Box(.failure)
        userState = Box(.unfollowed)
        isSelected = Box(false)
    }
    
    func start() {
        if let image = image {
            imageState.value = .loaded(image: image)
        } else {
            imageState.value = .loading
            networkManager.getImage(path: user.profileImage) { [weak self] result in
                switch result {
                case .success(let data):
                    guard let newImage = UIImage(data: data) else { return }
                    self?.image = newImage
                    self?.imageState.value = .loaded(image: newImage)
                case .failure:
                    self?.imageState.value = .failure
                }
            }
        }
    }
    
    func toggleFollow() {
        userState.value = userState.value == .followed ? .unfollowed : .followed
    }
    
    func blockUser() {
        userState.value = .blocked
        isSelected.value = false
        delegate.updateList()
    }
}
