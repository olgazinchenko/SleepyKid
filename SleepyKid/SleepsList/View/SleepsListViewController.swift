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
        registerObserver()
        
        viewModel?.reloadTable = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - Private Methods
    private func setupTableView() {
        tableView.register(SleepTableViewCell.self,
                           forCellReuseIdentifier: "SleepTableViewCell")
        tableView.separatorStyle = .none
        
        guard let name = viewModel?.kid.name else { return }
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
        let sleepViewController = SleepViewController()
        let kid = viewModel?.kid
        let viewModel = SleepViewModel(sleep: nil, kid: kid)
        sleepViewController.viewModel = viewModel
        sleepViewController.setSleep(sleep: nil)
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
        viewModel?.getSleeps(for: viewModel?.kid ?? Kid(id: UUID(),
                                                        name: "",
                                                        birthDate: .now))
    }
}

// MARK: - UITableViewDataSource
extension SleepsListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        viewModel?.section.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView,
                            titleForHeaderInSection section: Int) -> String? {
        viewModel?.section[section].title
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        viewModel?.section[section].items.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SleepTableViewCell",
                                                       for: indexPath) 
                as? SleepTableViewCell,
              let sleep = viewModel?.section[indexPath.section].items[indexPath.row]
                as? Sleep else { return UITableViewCell() }
        
        let kid = viewModel?.kid
        let viewModel = SleepViewModel(sleep: sleep, kid: kid)
        cell.viewModel = viewModel
        cell.setSleep(sleep: sleep, count: indexPath.row)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SleepsListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sleep = viewModel?.section[indexPath.section].items[indexPath.row]
                as? Sleep else { return }
        
        let kid = viewModel?.kid
        let sleepViewController = SleepViewController()
        let viewModel = SleepViewModel(sleep: sleep, kid: kid)
        sleepViewController.viewModel = viewModel
        sleepViewController.setSleep(sleep: sleep)
        navigationController?.pushViewController(sleepViewController, animated: true)
    }
}
