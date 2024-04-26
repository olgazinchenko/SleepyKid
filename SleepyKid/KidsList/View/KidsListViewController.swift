//
//  KidsListViewController.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 26/04/2024.
//

import UIKit

class KidsListViewController: UITableViewController {
    // MARK: - Properties
    var viewModel: KidsListViewModelProtocol?
    
    // MARK: - Live Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupToolBar()
    }
    
    // MARK: - Private Methods
    private func setupTableView() {
        tableView.register(KidTableViewCell.self,
                           forCellReuseIdentifier: "KidTableViewCell")
        tableView.separatorStyle = .none
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

// MARK: - UITableViewDataSource
extension KidsListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let viewModel = KidsListViewModel()
        return viewModel.kids.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "KidTableViewCell", for: indexPath) as? KidTableViewCell
        else { return UITableViewCell() }
        return cell
    }
}

