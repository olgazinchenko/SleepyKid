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
    weak var coordinator: AppCoordinator?
    private let dateHeader: DateTimelineHeaderView
    
    // MARK: - Initialization
    init(viewModel: SleepsListViewModelProtocol, startDate: Date) {
        self.viewModel = viewModel
        self.dateHeader = DateTimelineHeaderView(startDate: startDate,
                                                 frame: CGRect(x: 0,
                                                               y: 0,
                                                               width: UIScreen.main.bounds.width,
                                                               height: 60))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Live Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateHeader.delegate = self
        tableView.tableHeaderView = dateHeader
        
        setupUI()
        
        viewModel.reloadTable = { [weak self] in
            self?.tableView.reloadData()
        }
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
        label.text = "\(viewModel.kidName) 😴 sleeps".uppercased()
        label.font = UIFont(name: "Poppins-Bold", size: Layer.screenTitleFontSize.rawValue)
        label.textColor = .label
        navigationItem.titleView = label
    }
    
    private func setupTableView() {
        tableView.register(SleepTableViewCell.self,
                           forCellReuseIdentifier: "SleepTableViewCell")
        tableView.register(SleepAwakeDurationCell.self,
                           forCellReuseIdentifier: "SleepAwakeDurationCell")
        tableView.separatorStyle = .none
        setupTableHeader()
    }
    
    private func setupToolBar() {
        let addButton = UIBarButtonItem(title: "+Add",
                                        style: .done,
                                        target: self,
                                        action: #selector(addSleep))
        let spacing = UIBarButtonItem(systemItem: .flexibleSpace)
        
        setToolbarItems([spacing, addButton], animated: true)
        navigationController?.isToolbarHidden = false
    }
    
    @objc
    private func addSleep() {
        coordinator?.showSleepViewController(for: nil, sleepNumber: nil, kid: viewModel.kid)
    }
    
    private func registerObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateData),
                                               name: NSNotification.Name("Update"),
                                               object: nil)
    }
    
    @objc
    private func updateData() {
        // TODO: - Update the method in the viewModel
        viewModel.getSleeps(for: viewModel.kid, on: .now)
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
        
        if viewModel.isAwakeDurationRow(at: indexPath) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SleepAwakeDurationCell",
                                                           for: indexPath) as? SleepAwakeDurationCell
            else { return UITableViewCell() }
            
            let awakeDuration = viewModel.getAwakeDuration(for: indexPath)
            cell.setAwakeDuration(awakeDuration)
            cell.isUserInteractionEnabled = false
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SleepTableViewCell",
                                                           for: indexPath) as? SleepTableViewCell
            else { return UITableViewCell() }
            
            let sleep = viewModel.getSleep(for: viewModel.kid, and: indexPath)
            let sectionItems = viewModel.section[indexPath.section].items
            let sleepIndexInSection = sectionItems
                .enumerated()
                .filter { $0.element is Sleep }
                .firstIndex(where: { ($0.element as? Sleep)?.id == sleep.id }) ?? 0
            let sleepViewModel = SleepViewModel(sleep: sleep,
                                                sleepNumber: sleepIndexInSection,
                                                kid: viewModel.kid)
            cell.viewModel = sleepViewModel
            cell.setSleep(sleep: sleep, count: sleepIndexInSection)
            cell.selectionStyle = .none
            
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension SleepsListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !viewModel.isAwakeDurationRow(at: indexPath) {
            let sleep = viewModel.getSleep(for: viewModel.kid, and: indexPath)
            let sectionItems = viewModel.section[indexPath.section].items
            let sleepIndexInSection = sectionItems
                .enumerated()
                .filter { $0.element is Sleep }
                .firstIndex(where: { ($0.element as? Sleep)?.id == sleep.id }) ?? 0
            coordinator?.showSleepViewController(for: sleep,
                                                 sleepNumber: sleepIndexInSection,
                                                 kid: viewModel.kid)
        }
    }
}

// MARK: - DateTimelineHeaderViewDelegate
extension SleepsListViewController: DateTimelineHeaderViewDelegate {
    internal func didSelectDate(_ date: Date) {
        viewModel.getSleeps(for: viewModel.kid, on: date)
        tableView.reloadData()
    }
}
