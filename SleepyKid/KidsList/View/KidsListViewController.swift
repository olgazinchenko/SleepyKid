//
//  KidsListViewController.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 26/04/2024.
//

import UIKit

class KidsListViewController: UITableViewController {
    // MARK: - Properties
    var viewModel: KidsListViewModelProtocol
    
    // MARK: - Live Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupToolBar()
        registerObserver()
        
        viewModel.reloadTable = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    init(viewModel: KidsListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupTableView() {
        tableView.register(KidTableViewCell.self,
                           forCellReuseIdentifier: "KidTableViewCell")
        tableView.separatorStyle = .none
        title = "Kids".uppercased()
    }
    
    private func setupToolBar() {
        let addButton = UIBarButtonItem(title: "+Add",
                                        style: .done,
                                        target: self,
                                        action: #selector(addKid))
        let spacing = UIBarButtonItem(systemItem: .flexibleSpace)
        
        // Make addButton VoiceOver accessible
        addButton.isAccessibilityElement = true
        addButton.accessibilityLabel = "Add new kid"
        addButton.accessibilityTraits = .button
        
        setToolbarItems([spacing, addButton], animated: true)
        navigationController?.isToolbarHidden = false
    }
    
    @objc
    private func addKid() {
        let kidViewModel = KidViewModel()
        let kidViewController = KidViewController(viewModel: kidViewModel)
        
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
        viewModel.getKids()
    }
}

// MARK: - UITableViewDataSource
extension KidsListViewController {
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        viewModel.kids.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "KidTableViewCell",
                                                       for: indexPath) as? KidTableViewCell
        else { return UITableViewCell() }
        
        let kid = viewModel.getKid(for: indexPath.row)
        cell.setKid(name: kid.name)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension KidsListViewController {
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        let kid = viewModel.getKid(for: indexPath.row)
        let sleepListViewModel = SleepsListViewModel(sleeps: kid.sleeps, kid: kid)
        let sleepsListViewController = SleepsListViewController(viewModel: sleepListViewModel)
        
        navigationController?.pushViewController(sleepsListViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt
                            indexPath: IndexPath,
                            point: CGPoint) -> UIContextMenuConfiguration? {
        let kid = viewModel.getKid(for: indexPath.row)
        let kidViewModel = KidViewModel(kid: kid)
        let kidViewController = KidViewController(viewModel: kidViewModel)
        let provider: UIContextMenuActionProvider = { _ in
            UIMenu(title: "", children: [
                UIAction(title: "Edit", image: UIImage(systemName: "square.and.pencil")) { _ in
                    self.navigationController?.pushViewController(kidViewController,
                                                                  animated: true)
                },
                UIAction(title: "Delete", image: UIImage(systemName: "trash") ) { _ in
                    kidViewModel.delete()
                }
            ])
        }
        
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: provider)
    }
}
