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
        label.text = Text.startDate.rawValue
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .mainBlue
        return label
    }()
    
    private let endDateLabel: UILabel = {
        let label = UILabel()
        label.text = Text.endDate.rawValue
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .mainBlue
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
        view.image = UIImage(systemName: Text.timeImageName.rawValue)
        return view
    }()
    
    private let sleepDurationLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 17)
        label.tintColor = .mainTextColor
        label.textColor = .mainBlue
        return label
    }()
    
    // MARK: - Properties
    var viewModel: SleepViewModelProtocol?
    var sleepType: Sleep.SleepType = .unowned
    var sleepImage = UIImage(systemName: Text.sleepImageDefaultName.rawValue)
    var sleepTextColor: UIColor = .black
    var sleepBackgroundColor: UIColor = .white
    
    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
    }
    
    // MARK: - Methods
    func setSleep(sleep: Sleep?) {
        guard let sleep = sleep else { return }
        let sleepIntervalText = DateHelper.shared.getSleepIntervalText(from: sleep.startDate, to: sleep.endDate)
        
        sleepType = DateHelper.shared.defineSleepType(from: sleep.startDate, to: sleep.endDate)
        
        startSleepDatePicker.date = sleep.startDate
        endSleepDatePicker.date = sleep.endDate
        sleepDurationLabel.text = sleepIntervalText
        
        updateUIFor(sleepType: sleepType)
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        view.addSubviews([startDateLabel, endDateLabel, startSleepDatePicker, endSleepDatePicker, iconView, sleepDurationLabel, timeImageView])
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
    
    private func updateUIFor(sleepType: Sleep.SleepType) {
        switch sleepType {
        case .day:
            sleepTextColor = .mainYellow
            sleepBackgroundColor = .lightYellow
            sleepImage = UIImage(systemName: Text.sleepDayImageName.rawValue)
            updateUI()
        case .night:
            sleepTextColor = .mainBlue
            sleepBackgroundColor = .mainPurple
            sleepImage = UIImage(systemName: Text.sleepNightImageName.rawValue)
            updateUI()
        case .unowned:
            sleepTextColor = .black
            sleepBackgroundColor = .white
            sleepImage = UIImage(systemName: Text.sleepImageDefaultName.rawValue)
            updateUI()
        }
    }
    
    private func updateUI() {
        iconView.tintColor = sleepTextColor
        timeImageView.tintColor = sleepTextColor
        sleepDurationLabel.textColor = sleepTextColor
        startDateLabel.textColor = sleepTextColor
        endDateLabel.textColor = sleepTextColor
        
        view.backgroundColor = sleepBackgroundColor
        iconView.image = sleepImage
        
        sleepDurationLabel.text = DateHelper.shared.getSleepIntervalText(from: startSleepDatePicker.date,
                                                                         to: endSleepDatePicker.date)

    }
    
    private func setupBars() {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save,
                                         target: self,
                                         action: #selector(saveAction))
        navigationItem.rightBarButtonItem = saveButton
        saveButton.isEnabled = true

        let trashButton = UIBarButtonItem(barButtonSystemItem: .trash,
                                          target: self,
                                          action: #selector(deleteAction))
        
        setToolbarItems([trashButton], animated: true)
        
        navigationItem.rightBarButtonItem = saveButton
        saveButton.isEnabled = true
        trashButton.isHidden = (viewModel?.sleep == nil) ? true : false
    }
    
    @objc
    private func saveAction() {
        viewModel?.save(with: startSleepDatePicker.date,
                        and: endSleepDatePicker.date)
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func deleteAction() {
        viewModel?.delete()
        navigationController?.popViewController(animated: true)
    }
    
    private func setupDatePicker() {
        self.startSleepDatePicker.addTarget(self, action: #selector(onDateValueChanged(_:)),
                                      for: .valueChanged)
        self.endSleepDatePicker.addTarget(self, action: #selector(onDateValueChanged(_:)),
                                      for: .valueChanged)
    }
    
    @objc
    private func onDateValueChanged(_ sender: UIDatePicker) {
        let sleepIntervalText = DateHelper.shared.getSleepIntervalText(from: startSleepDatePicker.date, 
                                                                       to: endSleepDatePicker.date)
        sleepDurationLabel.text = sleepIntervalText
        
        sleepType = DateHelper.shared.defineSleepType(from: startSleepDatePicker.date, 
                                                      to: endSleepDatePicker.date)
        updateUIFor(sleepType: sleepType)
    }
}
