//
//  SleepsListViewController.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 26/04/2024.
//

import UIKit

class SleepsListViewController: UITableViewController {
    // MARK: - Properties
    var viewModel: SleepsListViewModelProtocol
    
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
    
    init(viewModel: SleepsListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupTableView() {
        tableView.register(SleepTableViewCell.self,
                           forCellReuseIdentifier: "SleepTableViewCell")
        tableView.separatorStyle = .none
        title = "\(viewModel.kidName) 😴 sleeps".uppercased()
    }
    
    private func setupToolBar() {
        let addButton = UIBarButtonItem(title: "+Add",
                                        style: .done,
                                        target: self,
                                        action: #selector(addKid))
        let spacing = UIBarButtonItem(systemItem: .flexibleSpace)
        
        setToolbarItems([spacing, addButton], animated: true)
        navigationController?.isToolbarHidden = false
    }
    
    @objc
    private func addKid() {
        let sleepViewModel = SleepViewModel(sleep: nil, kid: viewModel.kid)
        let sleepViewController = SleepViewController(viewModel: sleepViewModel)
        
        sleepViewController.setSleep()
        navigationController?.pushViewController(sleepViewController, animated: true)
    }
    
    private func registerObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateData),
                                               name: NSNotification.Name("Update"),
                                               object: nil)
    }
    
    @objc
    private func updateData() {
        viewModel.getSleeps(for: viewModel.kid)
    }
}

// MARK: - UITableViewDataSource
extension SleepsListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sectionCount
    }
    
    override func tableView(_ tableView: UITableView,
                            titleForHeaderInSection section: Int) -> String? {
        viewModel.getTitle(for: section)
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        viewModel.getNumberOfRows(for: section)
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SleepTableViewCell",
                                                       for: indexPath) as? SleepTableViewCell
        else { return UITableViewCell() }
        
        let sleep = viewModel.getSleep(for: viewModel.kid, and: indexPath)
        let sleepViewModel = SleepViewModel(sleep: sleep, kid: viewModel.kid)
        
        cell.viewModel = sleepViewModel
        cell.setSleep(sleep: sleep, count: indexPath.row)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SleepsListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sleep = viewModel.getSleep(for: viewModel.kid, and: indexPath)
        let sleepViewModel = SleepViewModel(sleep: sleep, kid: viewModel.kid)
        let sleepViewController = SleepViewController(viewModel: sleepViewModel)
        
        navigationController?.pushViewController(sleepViewController, animated: true)
    }
}
