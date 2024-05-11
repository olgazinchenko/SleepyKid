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
        
        title = "Kids".uppercased()
        setupTableView()
        setupToolBar()
        registerObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel?.reloadTable = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - Private Methods
    private func setupTableView() {
        tableView.register(KidTableViewCell.self,
                           forCellReuseIdentifier: "KidTableViewCell")
        tableView.separatorStyle = .none
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
         let kidViewController = KidViewController()
         let viewModel = KidViewModel(kid: nil)
         kidViewController.viewModel = viewModel
         viewModel.isNewKid = true
         navigationController?.pushViewController(kidViewController, animated: true)
     }
    
    private func registerObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateData),
                                               name: NSNotification.Name("Update"),
                                               object: nil)
    }
    
    @objc
    private func updateData() {
        viewModel?.getKids()
    }
}

// MARK: - UITableViewDataSource
extension KidsListViewController {
    override func tableView(_ tableView: UITableView, 
                            numberOfRowsInSection section: Int) -> Int {
        let viewModel = KidsListViewModel()
        return viewModel.kids.count
    }
    
    override func tableView(_ tableView: UITableView, 
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "KidTableViewCell", 
                                                       for: indexPath) as? KidTableViewCell,
              let kid = viewModel?.kids[indexPath.row] else { return UITableViewCell() }
        cell.setKid(name: kid.name)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension KidsListViewController {
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        guard let kid = viewModel?.kids[indexPath.row] as? Kid else { return }
        let sleepsListViewController = SleepsListViewController()
        let viewModel = SleepsListViewModel(sleeps: kid.sleeps, kidName: kid.name)
        sleepsListViewController.viewModel = viewModel
        navigationController?.pushViewController(sleepsListViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
            let provider: UIContextMenuActionProvider = { _ in
                UIMenu(title: "", children: [
                    UIAction(title: "Edit", image: UIImage(systemName: "square.and.pencil")) { _ in
                        let kidViewController = KidViewController()
                        let viewModel = KidViewModel(kid: self.viewModel?.kids[indexPath.row])
                        viewModel.isNewKid = false
                        kidViewController.viewModel = viewModel
                        self.navigationController?.pushViewController(kidViewController, animated: true)
                    },
                    UIAction(title: "Delete", image: UIImage(systemName: "trash") ) { _ in
                        // TODO: Delete action
                    }
                ])
            }
            
            return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: provider)
        }
}
