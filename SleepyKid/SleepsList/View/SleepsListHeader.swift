//
//  SleepsListHeader.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 25/07/2025.
//

import UIKit

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
    
    // MARK: - Initialization
    init(viewModel: SleepsListViewModelProtocol) {
        self.viewModel = viewModel
        
        super.init(frame: CGRect(x: 0,
                                 y: 0,
                                 width: UIScreen.main.bounds.width,
                                 height: 40))
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
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
}
