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
    weak var coordinator: AppCoordinator?
    
    // MARK: - Live Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
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
    func setupUI() {
        view.backgroundColor = .athensGray
        
        setupTableView()
        setupToolBar()
        registerObserver()
    }
    
    private func setupTableHeader() {
        let label = UILabel()
        label.text = "Kids".uppercased()
        label.font = UIFont(name: "Poppins-Bold", size: Layer.screenTitleFontSize.rawValue)
        label.textColor = .label
        navigationItem.titleView = label
    }
    
    private func setupTableView() {
        tableView.register(KidTableViewCell.self,
                           forCellReuseIdentifier: "KidTableViewCell")
        tableView.separatorStyle = .none
        setupTableHeader()
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
        coordinator?.showKidViewController(for: nil)
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
        let age = viewModel.getKidAdge(for: indexPath.row)
        cell.setKid(name: kid.name, age: age)
        cell.selectionStyle = .none
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension KidsListViewController {
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        let kid = viewModel.getKid(for: indexPath.row)
        let startDate = viewModel.getStartDate(for: kid)
        coordinator?.showSleepsListViewController(for: kid, startDate: startDate)
    }
    
    override func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt
                            indexPath: IndexPath,
                            point: CGPoint) -> UIContextMenuConfiguration? {
        let kid = viewModel.getKid(for: indexPath.row)
        let kidViewModel = KidViewModel(kid: kid)
        let provider: UIContextMenuActionProvider = { _ in
            UIMenu(title: "", children: [
                UIAction(title: "Edit", image: UIImage(systemName: "square.and.pencil")) { _ in
                    self.coordinator?.showKidViewController(for: kid)
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
