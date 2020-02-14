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
    
    var isSelected: Bindable<Bool>
    
    private (set) var imageState: Bindable<ImageState>
    
    private (set) var userState: Bindable<UserState>
    
    private let user: UsersResponse.Item
    
    private let networkManager: NetworkManager
        
    private var currentTask: URLSessionDownloadTask?
    
    private unowned let delegate: UserListViewModelDelegate
    
    init(
        _ user: UsersResponse.Item,
        delegate: UserListViewModelDelegate,
        networkManager: NetworkManager)
    {
        self.user = user
        self.networkManager = networkManager
        self.delegate = delegate
        imageState = Bindable(.failure)
        userState = Bindable(.unfollowed)
        isSelected = Bindable(false)
    }
    
    func didAppear() {
        switch imageState.value {
        case .failure:
            imageState.value = .loading
            currentTask = networkManager.getImage(path: user.profileImage) { [weak self] result in
                switch result {
                case .success(let data):
                    guard let newImage = UIImage(data: data) else { return }
                    // could be useful save the image in an NSCache but in this case there are only 20 cells
                    self?.imageState.value = .loaded(image: newImage)
                case .failure:
                    self?.imageState.value = .failure
                }
            }
        case .loading, .loaded:
            break
        }
    }
    
    func didDisappear() {
        // cancel the network task to not waste resources, in this case only the visible images are loaded
        currentTask?.cancel()
    }
    
    func toggleFollow() {
        // clould be a good improvement save this state in a persistent way but it wasn't required
        userState.value = userState.value == .followed ? .unfollowed : .followed
    }
    
    func blockUser() {
        // clould be a good improvement save this state in a persistent way but it wasn't required
        userState.value = .blocked
        isSelected.value = false
        delegate.updateList()
    }
}
