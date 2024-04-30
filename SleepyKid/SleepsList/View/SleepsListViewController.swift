//
//  SleepsListViewController.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 26/04/2024.
//

import UIKit

class SleepsListViewController: UITableViewController {
    // MARK: - Properties
    var viewModel: SleepsListViewModelProtocol?
    
    // MARK: - Live Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupToolBar()
    }
    
    // MARK: - Methods
    private func setupTableView() {
        tableView.register(SleepTableViewCell.self,
                           forCellReuseIdentifier: "SleepTableViewCell")
        tableView.separatorStyle = .none
        
        guard let name = viewModel?.kidName else { return }
        title = "\(name) 😴 sleeps".uppercased()
    }
    
    private func setupToolBar() {
            let addButton = UIBarButtonItem(title: "+Add",
                                            style: .done,
                                            target: self,
                                            action: #selector(addAction))
            let spacing = UIBarButtonItem(systemItem: .flexibleSpace)
            setToolbarItems([spacing, addButton], animated: true)
            navigationController?.isToolbarHidden = false
        }
    
    @objc
     private func addAction() {
         // TODO: addAction
     }
}

// MARK: - UITableViewDataSource
extension SleepsListViewController {
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRowsInSection = viewModel?.sleeps.count else { return 0 }
        return numberOfRowsInSection
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SleepTableViewCell",
                                                       for: indexPath) as? SleepTableViewCell,
              let sleep = viewModel?.sleeps[indexPath.row] else { return UITableViewCell() }
        let viewModel = SleepViewModel(sleep: sleep)
        cell.viewModel = viewModel
        cell.setSleep(sleep: sleep, count: indexPath.row)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SleepsListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sleep = viewModel?.sleeps[indexPath.row] as? Sleep else { return }
        let sleepViewController = SleepViewController()
        let viewModel = SleepViewModel(sleep: sleep)
        sleepViewController.viewModel = viewModel
        sleepViewController.setSleep(sleep: sleep)
        navigationController?.pushViewController(sleepViewController, animated: true)
    }
}
