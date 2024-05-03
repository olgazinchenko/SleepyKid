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
        label.text = "Kid name"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    private let kidNameTextField: UITextField = {
        let textField = UITextField()
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    private let dateOfBirthLabel: UILabel = {
        let label = UILabel()
        label.text = "Date of birth"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    private let dateOfBirthDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.layer.borderColor = UIColor.black.cgColor
        datePicker.layer.borderWidth = 1
        datePicker.layer.cornerRadius = 10
        datePicker.backgroundColor = .clear
        return datePicker
    }()
    
    private let boyOrGirlLabel: UILabel = {
        let label = UILabel()
        label.text = "Boy or girl?"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()
    
    private let iconView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "SleepyKid")
        return view
    }()
    
    private let boyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Boy", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .mainBlue
        button.layer.cornerRadius = 35
        button.layer.borderWidth = 5
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }()
    
    private let girlButton: UIButton = {
        let button = UIButton()
        button.setTitle("Girl", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .mainPink
        button.layer.cornerRadius = 35
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }()
    
    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
    }
    
    // MARK: - Properties
    var viewModel: KidViewModelProtocol?
    
    // MARK: - Private Methods
    private func setupUI() {
        view.addSubviews([kidNameLabel,
                          kidNameTextField,
                          dateOfBirthLabel,
                          dateOfBirthDatePicker,
                          boyOrGirlLabel,
                          boyButton,
                          girlButton,
                          iconView])
        setupConstraints()
        setupButtons()
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
        
        boyOrGirlLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.top.equalTo(dateOfBirthDatePicker.snp.bottom).offset(30)
        }
        
        boyButton.snp.makeConstraints {
            $0.top.equalTo(boyOrGirlLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo(70)
            $0.height.equalTo(70)
        }
        
        girlButton.snp.makeConstraints {
            $0.centerY.equalTo(boyButton.snp.centerY)
            $0.leading.equalTo(boyButton.snp.trailing).offset(20)
            $0.width.equalTo(70)
            $0.height.equalTo(70)
        }
        
        iconView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(girlButton.snp.bottom).offset(50)
            $0.width.equalToSuperview().multipliedBy(0.5) // 50% of the superview's width
            $0.height.equalTo(iconView.snp.width) // Square aspect ratio
            $0.bottom.lessThanOrEqualToSuperview().inset(50)
        }
    }
    
    private func setupButtons() {
        girlButton.addTarget(self, action: #selector(girlButtonTapped), for: .touchUpInside)
        boyButton.addTarget(self, action: #selector(boyButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func girlButtonTapped() {
        girlButton.layer.borderWidth = 5
        boyButton.layer.borderWidth = 1
    }
    
    @objc
    private func boyButtonTapped() {
        boyButton.layer.borderWidth = 5
        girlButton.layer.borderWidth = 1
    }

}
