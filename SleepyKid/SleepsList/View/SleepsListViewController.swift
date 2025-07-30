//
//  SleepsListViewController.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 26/04/2024.
//

import UIKit

class SleepsListViewController: UIViewController {
    // MARK: - GUI Variables
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Bold", size: Layer.screenTitleFontSize.rawValue)
        label.textColor = .label
        return label
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SleepTableViewCell.self,
                           forCellReuseIdentifier: "SleepTableViewCell")
        tableView.register(SleepAwakeDurationCell.self,
                           forCellReuseIdentifier: "SleepAwakeDurationCell")
        tableView.backgroundColor = .athensGray
        tableView.separatorStyle = .none
        return tableView
    }()
    
    let addButton = FloatingAddButton()
    
    // MARK: - Properties
    var viewModel: SleepsListViewModelProtocol
    weak var coordinator: AppCoordinator?
    private var selectedDate: Date = .now
    
    // MARK: - Initialization
    init(viewModel: SleepsListViewModelProtocol, startDate: Date) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Live Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        
        setupUI()
        
        viewModel.reloadTable = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setToolbar(hidden: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setToolbar(hidden: false)
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        view.backgroundColor = .athensGray
        view.addSubviews([tableView,
                          titleLabel,
                          addButton])
        
        setupTableView()
        setupToolBar()
        registerObserver()
        addTargets()
        setupConstraints()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        setupScreeHeader()
    }
    
    private func setupScreeHeader() {
        titleLabel.text = "\(viewModel.kidName) 😴 sleeps".uppercased()
        navigationItem.titleView = titleLabel
    }
    
    private func setupToolBar() {
        let addButton = UIBarButtonItem(title: "+Add",
                                        style: .done,
                                        target: self,
                                        action: #selector(addButtonTapped))
        let spacing = UIBarButtonItem(systemItem: .flexibleSpace)
        
        setToolbarItems([spacing, addButton], animated: true)
    }
    
    private func setToolbar(hidden: Bool) {
        navigationController?.toolbar.isHidden = hidden
    }
    
    private func addTargets() {
        addButton.button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        addButton.snp.makeConstraints {
            $0.height.width.equalTo(Layer.actionButtonSize.rawValue)
            $0.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc
    private func addButtonTapped() {
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
        viewModel.getSleeps(for: viewModel.kid, on: .now)
    }
}

// MARK: - UITableViewDataSource
extension SleepsListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sectionCount
    }
    
    func tableView(_ tableView: UITableView,
                            titleForHeaderInSection section: Int) -> String? {
        viewModel.getTitle(for: section)
    }
    
    func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        viewModel.getNumberOfRows(for: section)
    }
    
    func tableView(_ tableView: UITableView,
                            viewForHeaderInSection section: Int) -> UIView? {
        let header = SleepsListHeader(viewModel: viewModel)
        header.delegate = self
        header.setDate(selectedDate)
        return header
    }
    
    func tableView(_ tableView: UITableView,
                            heightForHeaderInSection section: Int) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView,
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
            cell.setSleep(sleep: sleep)
            cell.selectionStyle = .none
            
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension SleepsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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

// MARK: - SleepsListHeaderDelegate
extension SleepsListViewController: SleepsListHeaderDelegate {
    func sleepsListHeader(_ header: SleepsListHeader, didPick date: Date) {
        selectedDate = date
        viewModel.getSleeps(for: viewModel.kid, on: date)
        tableView.reloadData()
    }
}
