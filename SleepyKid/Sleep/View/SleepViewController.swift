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
        label.text = "Start time and date"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .mainBlue
        return label
    }()
    
    private let endDateLabel: UILabel = {
        let label = UILabel()
        label.text = "End time and date"
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
        view.image = UIImage(systemName: "calendar.badge.clock")
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
    
    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Methods
    func setSleep(sleep: Sleep) {
        let sleepInterval = sleep.endDate.timeIntervalSince(sleep.startDate)
        let (hours, minutes) = viewModel?.secondsToHoursMinutes(seconds: Int(sleepInterval)) ?? (0, 0)
        guard let sleepType = viewModel?.defineSleepType(from: sleep.startDate,
                                                         to: sleep.endDate) else { return }
        startSleepDatePicker.date = sleep.startDate
        endSleepDatePicker.date = sleep.endDate
        sleepDurationLabel.text = "\(hours) h \(minutes) min"
        updateUIFor(sleepType)
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        view.addSubviews([startDateLabel,
                         endDateLabel,
                         startSleepDatePicker,
                         endSleepDatePicker,
                         iconView,
                         sleepDurationLabel,
                         timeImageView])
        
        setupConstraints()
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
            $0.top.equalTo(sleepDurationLabel.snp.bottom).offset(30)
            $0.height.width.equalTo(400)
        }
    }
    
    private func updateUIFor(_ sleepType: Sleep.SleepType) {
        let sunImage = UIImage(systemName: "sun.max")
        let moonImage = UIImage(systemName: "moon.zzz")
        let pickedColor: UIColor = {
            return (sleepType == .day) ? .mainYellow : .mainBlue
        }()

        iconView.tintColor = pickedColor
        timeImageView.tintColor = pickedColor
        sleepDurationLabel.textColor = pickedColor
        startDateLabel.textColor = pickedColor
        endDateLabel.textColor = pickedColor
        
        view.backgroundColor = (sleepType == .day) ? .lightYellow : .mainPurple
        iconView.image = (sleepType == .day) ? sunImage : moonImage
    }
}
