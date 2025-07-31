//
//  KidsListViewController.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 26/04/2024.
//

import UIKit

class KidsListViewController: UIViewController {
    // MARK: - GUI Variables
    private let tableHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Kids".uppercased()
        label.font = UIFont(name: "Poppins-Bold", size: Layer.screenTitleFontSize.rawValue)
        label.textColor = .label
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .athensGray
        tableView.register(KidTableViewCell.self,
                           forCellReuseIdentifier: "KidTableViewCell")
        return tableView
    }()
    
    private let emptyStateLabel = EmptyStateLabel(message: Constant.kidsEmptyState.rawValue)
    
    private let addButton = FloatingActionButton(icon: UIImage(systemName: "plus"),
                                                               backgroundColor: .systemOrange)
    
    // MARK: - Properties
    var viewModel: KidsListViewModelProtocol
    weak var coordinator: AppCoordinator?
    
    // MARK: - Initialization
    init(viewModel: KidsListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Live Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.toolbar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        reloadDataAndUpdateUI()
        
        viewModel.reloadTable = { [weak self] in
            self?.reloadDataAndUpdateUI()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.toolbar.isHidden = false
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        view.backgroundColor = .athensGray
        view.addSubviews([tableView,
                          emptyStateLabel,
                          addButton])
        
        setupTableView()
        setupConstraints()
        registerObserver()
        addTargets()
    }
    
    private func setupTableHeader() {
        navigationItem.titleView = tableHeaderLabel
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        setupTableHeader()
    }
    
    private func updateEmptyStateVisibility() {
        emptyStateLabel.isHidden = !viewModel.kids.isEmpty
    }
    
    private func reloadDataAndUpdateUI() {
        tableView.reloadData()
        updateEmptyStateVisibility()
    }
    
    private func registerObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateData),
                                               name: NSNotification.Name("Update"),
                                               object: nil)
    }
    
    private func addTargets() {
        addButton.button.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    private func showDeleteConfirmation(title: String,
                                        message: String,
                                        onConfirm: @escaping () -> Void) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constant.cancel.rawValue, style: .cancel))
        alert.addAction(UIAlertAction(title: Constant.delete.rawValue, style: .destructive) { _ in
            onConfirm()
        })
        present(alert, animated: true)
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
        
        emptyStateLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-40)
            $0.leading.trailing.equalToSuperview().inset(32)
        }
    }
    
    @objc private func addButtonTapped() {
        coordinator?.showKidViewController(for: nil)
    }
    
    @objc
    private func updateData() {
        viewModel.getKids()
    }
}
 
// MARK: - UITableViewDataSource
extension KidsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        viewModel.kids.count
    }
    
    func tableView(_ tableView: UITableView,
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
extension KidsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let kid = viewModel.getKid(for: indexPath.row)
        let startDate = viewModel.getStartDate(for: kid)
        coordinator?.showSleepsListViewController(for: kid, startDate: startDate)
    }
    
    func tableView(_ tableView: UITableView,
                   contextMenuConfigurationForRowAt
                   indexPath: IndexPath,
                   point: CGPoint) -> UIContextMenuConfiguration? {
        let kid = viewModel.getKid(for: indexPath.row)
        let kidViewModel = KidViewModel(kid: kid)
        let provider: UIContextMenuActionProvider = { _ in
            UIMenu(title: "", children: [
                UIAction(title: Constant.edit.rawValue,
                         image: UIImage(systemName: Constant.editIcon.rawValue)) { _ in
                    self.coordinator?.showKidViewController(for: kid)
                },
                UIAction(title: Constant.delete.rawValue,
                         image: UIImage(systemName: Constant.deleteIcon.rawValue) ) { _ in
                    self.showDeleteConfirmation(title: Constant.deleteKidAlertTitle.rawValue,
                                                message: Constant.deleteKidAlertText.rawValue) {
                        kidViewModel.delete()
                    }
                }
            ])
        }
        
        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: nil,
                                          actionProvider: provider)
    }
}
