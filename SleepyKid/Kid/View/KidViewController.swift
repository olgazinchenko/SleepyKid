//
//  KidViewController.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 30/04/2024.
//

import UIKit

final class KidViewController: UIViewController {
    // MARK: - GUI Variables
    private let kidNameLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.kidName.rawValue
        label.font = UIFont(name: "Poppins-Medium", size: UIConstants.FontSize.labelLarge)
        label.textColor = .black
        return label
    }()
    
    private let kidNameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .mischka
        textField.borderStyle = .roundedRect
        textField.placeholder = Constant.name.rawValue
        textField.layer.borderColor = UIColor.black.cgColor
        textField.font = UIFont(name: "Poppins-Light", size: UIConstants.FontSize.labelLarge)
        return textField
    }()
    
    private let dateOfBirthLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = Constant.dateOfBirth.rawValue
        label.font = UIFont(name: "Poppins-Medium", size: UIConstants.FontSize.labelLarge)
        return label
    }()
    
    private let dateOfBirthDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        return datePicker
    }()
    
    private let iconView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: Constant.appIcon.rawValue)
        return view
    }()
    
    private let kidCell = KidTableViewCell()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Bold", size: UIConstants.FontSize.screenTitle)
        label.textColor = .mainTextColor
        label.sizeToFit()
        return label
    }()
    
    private let deleteButton = FloatingActionButton(icon: UIImage(systemName: "trash"),
                                                    backgroundColor: .systemRed)
    
    // MARK: - Properties
    var viewModel: KidViewModelProtocol?
    
    // MARK: - Initialization
    init(viewModel: KidViewModelProtocol?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configure()
        addTargets()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        navigationItem.titleView = titleLabel
        view.backgroundColor = .athensGray
        view.addSubviews([kidCell,
                          kidNameLabel,
                          kidNameTextField,
                          dateOfBirthLabel,
                          dateOfBirthDatePicker,
                          deleteButton])
        setupConstraints()
        setupBars()
        hideKeyboardWhenTappedOnScreen()
    }
    
    private func setupConstraints() {
        kidCell.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(15)
            $0.height.equalTo(90)
        }
        
        kidNameLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalTo(kidCell.snp.bottom).offset(25)
        }
        
        kidNameTextField.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalTo(kidNameLabel.snp.bottom).offset(10)
            $0.height.equalTo(35)
        }
        
        dateOfBirthLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalTo(kidNameTextField.snp.bottom).offset(30)
        }
        
        dateOfBirthDatePicker.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(dateOfBirthLabel.snp.bottom)
            $0.height.equalTo(50)
        }
        
        deleteButton.snp.makeConstraints {
            $0.height.width.equalTo(UIConstants.Button.actionSize)
            $0.leading.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
    }
    
    private func configure() {
        guard var viewModel else { return }
        let isNew = viewModel.kid == nil
        
        titleLabel.text = (isNew ? Constant.add : Constant.edit).rawValue.uppercased()
        if isNew {
            viewModel.kid = Kid(id: UUID(), name: "", birthDate: .now)
            deleteButton.isHidden = true
        }
        
        kidCell.setKid(name: viewModel.kidName, age: viewModel.kidAge)
        kidNameTextField.text = viewModel.kidName
        kidNameTextField.becomeFirstResponder()
        kidNameTextField.addTarget(self,
                            action: #selector(updateKidCell),
                            for: .editingChanged)
        dateOfBirthDatePicker.date = viewModel.kidBirthDate
        dateOfBirthDatePicker.addTarget(self,
                             action: #selector(updateKidCell),
                             for: .valueChanged)
    }
    
    private func setupBars() {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save,
                                         target: self,
                                         action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = saveButton
        saveButton.isEnabled = true
    }
    
    private func addTargets() {
        deleteButton.button.addTarget(self,
                                      action: #selector(deleteButtonTapped),
                                      for: .touchUpInside)
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
    
    @objc
    private func saveButtonTapped() {
        guard let viewModel else { return }
        viewModel.save(with: kidNameTextField.text ?? "",
                       and: dateOfBirthDatePicker.date)
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func deleteButtonTapped() {
        showDeleteConfirmation(title: Constant.deleteKidAlertTitle.rawValue,
                               message: Constant.deleteKidAlertText.rawValue) { [weak self] in
            self?.viewModel?.delete()
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc
    private func updateKidCell() {
        let name = kidNameTextField.text ?? ""
        let birthDate = dateOfBirthDatePicker.date
        let age = DateHelper.shared.getKidAge(birthDate: birthDate)
        kidCell.setKid(name: name, age: age)
    }
}
