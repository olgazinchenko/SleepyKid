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
        label.text = Text.kidName.rawValue
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    private let kidNameTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderColor = UIColor.black.cgColor
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .systemGray6
        return textField
    }()
    
    private let dateOfBirthLabel: UILabel = {
        let label = UILabel()
        label.text = Text.dateOfBirth.rawValue
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    private let dateOfBirthDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        return datePicker
    }()
    
    private let iconView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: Text.appIcon.rawValue)
        return view
    }()
    
    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
        configure()
    }
    
    // MARK: - Properties
    var viewModel: KidViewModelProtocol?
    
    // MARK: - Private Methods
    private func setupUI() {
        view.addSubviews([kidNameLabel,
                          kidNameTextField,
                          dateOfBirthLabel,
                          dateOfBirthDatePicker,
                          iconView])
        setupConstraints()
        setupBars()
        hideKeyboardWhenTappedOnScreen()
    }
    
    private func setupConstraints() {
        kidNameLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
        
        kidNameTextField.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalTo(kidNameLabel.snp.bottom).offset(5)
            $0.height.equalTo(50)
        }
        
        dateOfBirthLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalTo(kidNameTextField.snp.bottom).offset(30)
        }
        
        dateOfBirthDatePicker.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(dateOfBirthLabel.snp.bottom).offset(5)
            $0.height.equalTo(50)
        }
        
        iconView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(dateOfBirthDatePicker.snp.bottom).offset(50)
            $0.width.equalToSuperview().multipliedBy(0.7)
            $0.height.equalTo(iconView.snp.width) // Square aspect ratio
            $0.bottom.lessThanOrEqualToSuperview().inset(50)
        }
    }
    
    private func configure() {
        kidNameTextField.text = viewModel?.kid?.name ?? ""
        dateOfBirthDatePicker.date = viewModel?.kid?.birthDate ?? .now
    }
    
    private func setupBars() {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save,
                                         target: self,
                                         action: #selector(saveAction))
        navigationItem.rightBarButtonItem = saveButton
        saveButton.isEnabled = true
    }
    
    @objc
    private func saveAction() {
        guard let viewModel = viewModel else { return }
        viewModel.save(with: kidNameTextField.text ?? "",
                       and: dateOfBirthDatePicker.date)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Keyboard Events
extension KidViewController {
    func hideKeyboardWhenTappedOnScreen() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    func handleTap() {
        view.endEditing(true)
    }
}
