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
    
    // MARK: - Properties
    var viewModel: SleepsListViewModelProtocol
    weak var delegate: SleepsListHeaderDelegate?
    
    // MARK: - Initialization
    init(viewModel: SleepsListViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(frame: .zero)
        setupUI()
        
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        addSubview(containerView)
        containerView.addSubviews([datePicker])
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
    }
    
    func setDate(_ date: Date) {
      datePicker.date = date
    }
    
    @objc private func dateChanged(_ picker: UIDatePicker) {
      delegate?.sleepsListHeader(self, didPick: picker.date)
    }
}
