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
    
    private let tableView: UITableView
    
    private var currentAlert: UIAlertController = UIAlertController()
    
    init(viewModel: UserListViewModel) {
        self.viewModel = viewModel
        self.tableView = UITableView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBindings()
        configureTableView()
        makeView()
        viewModel.start()
    }
    
    private func makeView() {
        view.backgroundColor = .darkWhite
        let titleLabel = UILabel()
        titleLabel.text = "Top 20"
        titleLabel.font = titleLabel.font.withSize(50)
        let mainStack = UIStackView(arrangedSubviews: [
            .spacer(height: 40),
            titleLabel,
            tableView
        ])
        mainStack.axis = .vertical
        let stack = UIStackView(arrangedSubviews: [
            .spacer(widht: 10),
            mainStack,
            .spacer(widht: 10)
        ])
        stack.axis = .horizontal
        view.addSubview(stack)
        stack.autoPinToSuperview()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .clear
        tableView.register(UserCellView.self, forCellReuseIdentifier: UserCellView.identifier)
    }
    
    private func configureBindings() {
        viewModel.state.bind { [weak self] state in
            self?.currentAlert.dismiss(animated: false) {
                self?.stateDidChange(state: state)
            }
        }
    }
    
    private func stateDidChange(state: UserListViewModel.State) {
        switch state {
        case .loading:
            let alert = UIAlertController(title: "Loading...", message: nil, preferredStyle: .alert)
            currentAlert = alert
            present(alert, animated: true)
        case .failure:
            // for demo reasons I'm not going to handle different kind of errors
            let alert = UIAlertController(
                title: "Error",
                message: "Generic Error!",
                preferredStyle: .alert
            )
            alert.addAction(.init(title: "Retry", style: .default) { [weak self] _ in
                self?.viewModel.start()
            })
            currentAlert = alert
            present(alert, animated: true)
        case .loaded:
            tableView.reloadData()
        case .updated:
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }

}

extension UserListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCellView.identifier)
        guard let userCell = cell as? UserCellView else { return UITableViewCell() }
        userCell.configure(viewModel: viewModel.dataSource[indexPath.row])
        return userCell
    }
}

extension UserListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelect(row: indexPath.row)
    }
}
