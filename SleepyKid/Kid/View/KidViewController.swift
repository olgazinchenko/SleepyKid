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
        label.font = UIFont(name: "Poppins-Medium", size: Layer.labelFontSizeLarge.rawValue)
        label.textColor = .black
        return label
    }()
    
    private let kidNameTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderColor = UIColor.black.cgColor
        textField.font = UIFont(name: "Poppins-Light", size: Layer.labelFontSizeLarge.rawValue)
        textField.borderStyle = .roundedRect
        textField.placeholder = Constant.name.rawValue
        textField.backgroundColor = .mischka
        return textField
    }()
    
    private let dateOfBirthLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.dateOfBirth.rawValue
        label.font = UIFont(name: "Poppins-Medium", size: Layer.labelFontSizeLarge.rawValue)
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
    
    private let kidCell = KidTableViewCell()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.edit.rawValue.uppercased()
        label.font = UIFont(name: "Poppins-Bold", size: Layer.screenTitleFontSize.rawValue)
        label.textColor = .mainTextColor
        label.sizeToFit()
        return label
    }()
    
    // MARK: - Properties
    var viewModel: KidViewModelProtocol?
    
    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configure()
    }
    
    init(viewModel: KidViewModelProtocol?) {
        self.viewModel = viewModel
        kidCell.setKid(name: viewModel?.kidName ?? "", age: viewModel?.kidAge ?? "--")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        navigationItem.titleView = titleLabel
        view.backgroundColor = .athensGray
        view.addSubviews([kidCell,
                          kidNameLabel,
                          kidNameTextField,
                          dateOfBirthLabel,
                          dateOfBirthDatePicker])
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
    }
    
    private func configure() {
        guard let viewModel else { return }
        kidNameTextField.text = viewModel.kidName
        dateOfBirthDatePicker.date = viewModel.kidBirthDate
    }
    
    private func setupBars() {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save,
                                         target: self,
                                         action: #selector(saveSleep))
        navigationItem.rightBarButtonItem = saveButton
        saveButton.isEnabled = true
    }
    
    @objc
    private func saveSleep() {
        guard let viewModel else { return }
        viewModel.save(with: kidNameTextField.text ?? "",
                       and: dateOfBirthDatePicker.date)
        navigationController?.popViewController(animated: true)
    }
}
