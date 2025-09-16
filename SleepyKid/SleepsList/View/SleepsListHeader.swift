//
//  SleepsListHeader.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 25/07/2025.
//

import UIKit

protocol SleepsListHeaderDelegate: AnyObject {
  func sleepsListHeader(_ header: SleepsListHeader, didPick date: Date)
}

final class SleepsListHeader: UIView {
    // MARK: - GUI Variables
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .athensGray.withAlphaComponent(0.90)
        view.isOpaque = false
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.mischka.cgColor
        return view
    }()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        return datePicker
    }()
    
    private let rightArrowButton = ArrowButton(direction: .right)
    
    private let leftArrowButton = ArrowButton(direction: .left)
    
    // MARK: - Properties
    var viewModel: SleepsListViewModelProtocol
    weak var delegate: SleepsListHeaderDelegate?
    
    // MARK: - Initialization
    init(viewModel: SleepsListViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(frame: .zero)
        setupUI()
        
        datePicker.maximumDate = DateHelper.shared.getStartOfDay(for: .now)
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        rightArrowButton.addTarget(self, action: #selector(setNextDate), for: .touchUpInside)
        leftArrowButton.addTarget(self, action: #selector(setPreviousDate), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        addSubview(containerView)
        containerView.addSubviews([datePicker,
                                   rightArrowButton,
                                   leftArrowButton])
        setupConstraints()
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        datePicker.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.verticalEdges.equalToSuperview()
        }
        
        rightArrowButton.snp.makeConstraints {
            $0.leading.equalTo(datePicker.snp.trailing).offset(15)
            $0.width.height.equalTo(UIConstants.Button.arrowSize)
            $0.centerY.equalTo(datePicker.snp.centerY)
        }
        
        leftArrowButton.snp.makeConstraints {
            $0.trailing.equalTo(datePicker.snp.leading).offset(-15)
            $0.width.height.equalTo(UIConstants.Button.arrowSize)
            $0.centerY.equalTo(datePicker.snp.centerY)
        }
    }
    
    @objc private func dateChanged(_ picker: UIDatePicker) {
        delegate?.sleepsListHeader(self, didPick: picker.date)
    }
    
    @objc private func setNextDate() { stepDay(+1) }
    
    @objc private func setPreviousDate() { stepDay(-1) }
    
    private func stepDay(_ delta: Int) {
        let calendar = Calendar.current
        guard var newDate = calendar.date(byAdding: .day,
                                          value: delta,
                                          to: datePicker.date) else { return }
        
        if let min = datePicker.minimumDate, newDate < min { newDate = min }
        if let max = datePicker.maximumDate, newDate > max { newDate = max }
        
        datePicker.setDate(newDate, animated: true)
        delegate?.sleepsListHeader(self, didPick: newDate)
        updateArrowButtonsEnabled()
    }
    
    private func updateArrowButtonsEnabled() {
        let date = datePicker.date
        
        leftArrowButton.isEnabled = !(datePicker.minimumDate.map { date <= $0 } ?? false)
        rightArrowButton.isEnabled = !(datePicker.maximumDate.map { date >= $0 } ?? false)
    }
    
    // MARK: - Methods
    func setDate(_ date: Date) {
        datePicker.date = date
        updateArrowButtonsEnabled()
    }
}
