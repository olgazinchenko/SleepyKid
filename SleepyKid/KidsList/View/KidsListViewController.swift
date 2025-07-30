//
//  KidsListViewController.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 26/04/2024.
//

import UIKit

class KidsListViewController: UIViewController {
    // MARK: - GUI Variables
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .athensGray
        return tableView
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .orange
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Poppins-Regular",
                                         size: Layer.actionButtonTitleSize.rawValue)
        button.layer.cornerRadius = Layer.actionButtonCornerRadius.rawValue
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = Layer.actionButtonssHadowRadius.rawValue
        return button
    }()
    
    // MARK: - Properties
    var viewModel: KidsListViewModelProtocol
    weak var coordinator: AppCoordinator?
    
    // MARK: - Live Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.toolbar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        viewModel.reloadTable = { [weak tableView] in
            tableView?.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.toolbar.isHidden = false
    }
    
    // MARK: - Initialization
    init(viewModel: KidsListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        view.backgroundColor = .athensGray
        view.addSubviews([tableView,
                          addButton])
        
        setupTableView()
        setupConstraints()
        registerObserver()
    }
    
    private func setupTableHeader() {
        let label = UILabel()
        label.text = "Kids".uppercased()
        label.font = UIFont(name: "Poppins-Bold", size: Layer.screenTitleFontSize.rawValue)
        label.textColor = .label
        
        navigationItem.titleView = label
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    private func setupTableView() {
        tableView.register(KidTableViewCell.self,
                           forCellReuseIdentifier: "KidTableViewCell")
        tableView.separatorStyle = .none
        setupTableHeader()
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    private func registerObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateData),
                                               name: NSNotification.Name("Update"),
                                               object: nil)
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
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt
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
