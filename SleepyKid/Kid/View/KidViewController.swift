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
        label.text = Constant.dateOfBirth.rawValue
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
        view.image = UIImage(named: Constant.appIcon.rawValue)
        return view
    }()
    
    // MARK: - Properties
    var viewModel: KidViewModelProtocol?
    
    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configure()
        hideKeyboardWhenTappedOnScreen()
    }
    
    init(viewModel: KidViewModelProtocol?) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        view.backgroundColor = .white
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
        guard let viewModel else { return }
        kidNameTextField.text = viewModel.kidName
        dateOfBirthDatePicker.date = viewModel.kidBirthDate
    }
    
    private func setupBars() {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save,
                                         target: self,
                                         action: #selector(save))
        navigationItem.rightBarButtonItem = saveButton
        saveButton.isEnabled = true
    }
    
    @objc
    private func save() {
        guard let viewModel else { return }
        viewModel.save(with: kidNameTextField.text ?? "",
                       and: dateOfBirthDatePicker.date)
        navigationController?.popViewController(animated: true)
    }
}
