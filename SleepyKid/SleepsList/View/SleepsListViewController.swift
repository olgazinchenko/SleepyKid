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
        tableView.register(KidTableViewCell.self,
                           forCellReuseIdentifier: "SleepTableViewCell")
        tableView.separatorStyle = .none
        
        guard let name = viewModel?.kidName else { return }
        title = "\(name)'s sleeps".uppercased()
    }
    
    private func setupToolBar() {
            let addButton = UIBarButtonItem(title: "+Add",
                                            style: .plain,
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
