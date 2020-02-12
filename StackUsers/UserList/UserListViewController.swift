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
        viewModel.start()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.autoPinToSuperview()
    }
    
    private func configureBindings() {
        viewModel.state.bind { state in
            DispatchQueue.main.async { [weak self] in
                self?.currentAlert.dismiss(animated: false) {
                    self?.stateDidChange(state: state)
                }
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
        }
    }

}

extension UserListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = viewModel.dataSource[indexPath.row].displayName
        return cell
    }
}

extension UserListViewController: UITableViewDelegate {
    
}
