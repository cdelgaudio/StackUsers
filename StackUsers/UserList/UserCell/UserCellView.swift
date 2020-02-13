//
//  UserCellView.swift
//  StackUsers
//
//  Created by Carmine Del Gaudio on 12/02/2020.
//  Copyright © 2020 Carmine Del Gaudio. All rights reserved.
//

import UIKit

class UserCellView: UITableViewCell {

    private let nameLabel: UILabel
    private let reputationLabel: UILabel
    private let profileImageView: UIImageView
    private let blockedOverlay: UIView
    private let followButton: CellButton
    private let badgeimageView: UIImageView

    private var viewModel: UserCellViewModel?
    private var detailStack: UIStackView
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        nameLabel = UILabel()
        nameLabel.font = nameLabel.font.withSize(20)
        reputationLabel = UILabel()
        reputationLabel.font = reputationLabel.font.withSize(16)
        reputationLabel.textColor = .gray
        profileImageView = UIImageView()
        detailStack = UIStackView()
        blockedOverlay = UIView()
        followButton = CellButton()
        badgeimageView = UIImageView(image: UIImage(named: "rss")?.withRenderingMode(.alwaysTemplate))
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        makeView()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.backgroundColor = .clear
        profileImageView.image = nil
        detailStack.isHidden = true
    }
    
    func configure(viewModel: UserCellViewModel) {
        self.viewModel = viewModel
        nameLabel.text = viewModel.name
        reputationLabel.text = viewModel.reputation
        
        viewModel.imageState.bind { [weak self] state in
            self?.imageStateDidChange(state: state)
        }
        imageStateDidChange(state: viewModel.imageState.value)
        
        viewModel.isSelected.bind { [weak self] value in
            self?.detailStack.isHidden = !value
        }
        detailStack.isHidden = !viewModel.isSelected.value

        viewModel.userState.bind { [weak self] state in
            self?.userStateDidChange(state: state)
        }
        userStateDidChange(state: viewModel.userState.value)
        
        viewModel.start()
    }
    
    // MARK: State
    
    private func imageStateDidChange(state: UserCellViewModel.ImageState) {
        switch state {
        case .failure, .loading:
            profileImageView.backgroundColor = .lightGray
            profileImageView.image = nil
        case .loaded(let image):
            profileImageView.backgroundColor = .clear
            profileImageView.image = image
        }
    }
    
    private func userStateDidChange(state: UserCellViewModel.UserState) {
        blockedOverlay.isHidden = true
        followButton.isSelected = false
        badgeimageView.isHidden = true
        switch state {
        case .blocked:
            blockedOverlay.isHidden = false
        case .followed:
            followButton.isSelected = true
            badgeimageView.isHidden = false
        case .unfollowed:
            break
        }
    }
        
    // MARK: - View
    
    private func makeView() {
        makeContainerStack()
        
        profileImageView.autoPinDimensions(size: .init(width: 70, height: 70))
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 35
    }
    
    private func makeContainerStack() {
        detailStack = makeDetailStack()
        detailStack.isHidden = true
        let stack = UIStackView(arrangedSubviews: [
            makeMainStack(),
            detailStack,
            .spacer(height: 5)
        ])
        stack.axis = .vertical
        let containerView = UIView()
        containerView.addSubview(stack)
        stack.autoPinToSuperview()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 20
        let containerStack = UIStackView(arrangedSubviews: [
            .spacer(height: 2.5),
            containerView,
            .spacer(height: 2.5)
        ])
        containerStack.axis = .vertical
        contentView.addSubview(containerStack)
        containerStack.autoPinToSuperview()
        
        makeBlockedOverlay()
        containerView.addSubview(blockedOverlay)
        blockedOverlay.autoPinToSuperview()
    }
    
    private func makeMainStack() -> UIStackView {
        let textStack = UIStackView(arrangedSubviews: [
            .spacer(height: 0),
            nameLabel,
            reputationLabel,
            .flexibleSpacer()
        ])
        textStack.axis = .vertical
        textStack.spacing = 10
        let imageStack = UIStackView(arrangedSubviews: [
            .spacer(height: 10),
            profileImageView,
            .spacer(height: 10),
            .flexibleSpacer()
        ])
        imageStack.axis = .vertical
        let mainStack = UIStackView(arrangedSubviews: [
            .spacer(widht: 0),
            imageStack,
            textStack,
            .flexibleSpacer(),
            makeFollowBadgeStack(),
            .spacer(widht: 10)
        ])
        mainStack.axis = .horizontal
        mainStack.spacing = 10
        return mainStack
    }
    
    private func makeFollowBadgeStack() -> UIStackView {
        badgeimageView.isHidden = true
        badgeimageView.tintColor = .darkGreen
        badgeimageView.autoPinDimensions(size: .init(width: 15, height: 15))
         let stack = UIStackView(arrangedSubviews: [
             .spacer(height: 20),
             badgeimageView,
             .flexibleSpacer()
         ])
         stack.axis = .vertical
         return stack
     }
    
    private func makeBlockedOverlay() {
        blockedOverlay.backgroundColor = .gray
        blockedOverlay.alpha = 0.5
        blockedOverlay.isHidden = true
        blockedOverlay.layer.cornerRadius = 20
    }
    
    private func makeDetailStack() -> UIStackView {
        let followButton = makeFollowButton()
        let blockButton = makeBlockButton()
        let detailStack = UIStackView(arrangedSubviews: [
            .spacer(widht: 20),
            followButton,
            .spacer(widht: 20),
            blockButton,
            .spacer(widht: 20),
        ])
        detailStack.axis = .horizontal
        
        followButton.widthAnchor.constraint(
            equalTo: blockButton.widthAnchor, multiplier: 1
        ).isActive = true
        
        return detailStack
    }
    
    // MARK: Buttons
    
    private func makeFollowButton() -> UIButton {
        followButton.configureNormal(title: "Follow", tintColor: .darkGreen, backgroundColor: .white)
        followButton.configureSelected(title: "Followed", tintColor: .white, backgroundColor: .darkGreen)
        followButton.addTarget(self, action: #selector(followButtonPressed), for: .touchUpInside)
        return followButton
    }
    
    @objc func followButtonPressed() {
        viewModel?.toggleFollow()
    }
    
    private func makeBlockButton() -> UIButton {
        let blockButton = CellButton()
        blockButton.configureNormal(title: "Block", tintColor: .white, backgroundColor: .red)
        blockButton.addTarget(self, action: #selector(blockButtonPressed), for: .touchUpInside)
        return blockButton
    }
    
    @objc func blockButtonPressed() {
        viewModel?.blockUser()
    }
}
