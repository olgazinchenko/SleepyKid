//
//  SleepViewController.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 29/04/2024.
//

import UIKit
import SnapKit

final class SleepViewController: UIViewController {
    // MARK: - GUI Variables
    private let startDateLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.startDate.rawValue
        label.font = UIFont(name: "Poppins-Bold", size: 18)
        return label
    }()
    
    private let endDateLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.endDate.rawValue
        label.font = UIFont(name: "Poppins-Bold", size: 18)
        return label
    }()
    
    private let startSleepDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        return datePicker
    }()
    
    private let endSleepDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        return datePicker
    }()
    
    private let iconView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    private let timeImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: Constant.timeBadge.rawValue)
        return view
    }()
    
    private let sleepDurationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Bold", size: 17)
        return label
    }()
    
    // MARK: - Properties
    private var viewModel: SleepViewModelProtocol
    private var sleepImage: UIImage
    private var sleepTextColor: UIColor
    private var sleepBackgroundColor: UIColor
    
    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    init(viewModel: SleepViewModelProtocol) {
        self.viewModel = viewModel
        
        sleepImage = UIImage(systemName: Constant.unownedImage.rawValue) ?? .remove
        sleepTextColor = .systemGray
        sleepBackgroundColor = .white
        
        super.init(nibName: nil, bundle: nil)
        
        setSleep(sleep: viewModel.sleep)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func setSleep(sleep: Sleep? = nil) {
        guard let sleep else { return }
        
        let sleepIntervalText = viewModel.getSleepInterval(from: sleep.startDate,
                                                           to: sleep.endDate)
        let sleepType = viewModel.getSleepType(from: sleep.startDate,
                                               to: sleep.endDate)
        
        startSleepDatePicker.date = sleep.startDate
        endSleepDatePicker.date = sleep.endDate
        sleepDurationLabel.text = sleepIntervalText
        
        updateUIFor(sleepType: sleepType)
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubviews([startDateLabel,
                          endDateLabel,
                          startSleepDatePicker,
                          endSleepDatePicker,
                          iconView,
                          sleepDurationLabel,
                          timeImageView])
        setupConstraints()
        setupBars()
        setupDatePicker()
        updateUI()
    }
    
    private func setupConstraints() {
        startDateLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().offset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
        
        startSleepDatePicker.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(startDateLabel.snp.bottom).offset(10)
        }
        
        endDateLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().offset(20)
            $0.top.equalTo(startSleepDatePicker.snp.bottom).offset(30)
        }
        
        endSleepDatePicker.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(endDateLabel.snp.bottom).offset(10)
        }
        
        timeImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(endSleepDatePicker.snp.bottom).offset(30)
            $0.height.width.equalTo(22)
        }
        
        sleepDurationLabel.snp.makeConstraints {
            $0.leading.equalTo(timeImageView.snp.trailing).offset(5)
            $0.centerY.equalTo(timeImageView)
        }
        
        iconView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(sleepDurationLabel.snp.bottom).offset(50)
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.height.equalTo(iconView.snp.width) // Square aspect ratio
            $0.bottom.lessThanOrEqualToSuperview().inset(50)
        }
    }
    
    private func updateUIFor(sleepType: SleepType) {
        switch sleepType {
        case .day:
            sleepTextColor = .mainYellow
            sleepBackgroundColor = .lightYellow
            sleepImage = UIImage(systemName: Constant.dayImage.rawValue) ?? .remove
            updateUI()
        case .night:
            sleepTextColor = .mainBlue
            sleepBackgroundColor = .mainPurple
            sleepImage = UIImage(systemName: Constant.nightImage.rawValue) ?? .remove
            updateUI()
        case .unowned:
            sleepTextColor = .systemGray
            sleepBackgroundColor = .white
            sleepImage = UIImage(systemName: Constant.unownedImage.rawValue) ?? .remove
            updateUI()
        }
    }
    
    private func updateUI() {
        view.backgroundColor = sleepBackgroundColor
        
        iconView.tintColor = sleepTextColor
        timeImageView.tintColor = sleepTextColor
        sleepDurationLabel.textColor = sleepTextColor
        startDateLabel.textColor = sleepTextColor
        endDateLabel.textColor = sleepTextColor
        
        iconView.image = sleepImage
        sleepDurationLabel.text = viewModel.getSleepInterval(from: startSleepDatePicker.date,
                                                             to: endSleepDatePicker.date)
    }
    
    private func setupBars() {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save,
                                         target: self,
                                         action: #selector(saveSleep))
        let trashButton = UIBarButtonItem(barButtonSystemItem: .trash,
                                          target: self,
                                          action: #selector(deleteSleep))
        let spacing = UIBarButtonItem(systemItem: .flexibleSpace)
        
        navigationItem.rightBarButtonItem = saveButton
        setToolbarItems([trashButton, spacing], animated: true)
        saveButton.isEnabled = true
        trashButton.isHidden = viewModel.isNewSleep
    }
    
    @objc
    private func saveSleep() {
        viewModel.save(with: startSleepDatePicker.date,
                       and: endSleepDatePicker.date)
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func deleteSleep() {
        viewModel.delete()
        navigationController?.popViewController(animated: true)
    }
    
    private func setupDatePicker() {
        startSleepDatePicker.addTarget(self, action: #selector(onDateValueChanged(_:)),
                                       for: .valueChanged)
        endSleepDatePicker.addTarget(self, action: #selector(onDateValueChanged(_:)),
                                     for: .valueChanged)
    }
    
    @objc
    private func onDateValueChanged(_ sender: UIDatePicker) {
        let sleepIntervalText = viewModel.getSleepInterval(from: startSleepDatePicker.date,
                                                           to: endSleepDatePicker.date)
        let sleepType = viewModel.getSleepType(from: startSleepDatePicker.date,
                                               to: endSleepDatePicker.date)
        
        sleepDurationLabel.text = sleepIntervalText
        updateUIFor(sleepType: sleepType)
    }
}
