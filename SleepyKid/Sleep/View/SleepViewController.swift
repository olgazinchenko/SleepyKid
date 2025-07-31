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
        label.font = UIFont(name: "Poppins-Medium", size: Layer.labelFontSizeLarge.rawValue)
        return label
    }()
    
    private let endDateLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.endDate.rawValue
        label.font = UIFont(name: "Poppins-Medium", size: Layer.labelFontSizeLarge.rawValue)
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
    
    private let sleepCell = SleepTableViewCell()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.edit.rawValue.uppercased()
        label.font = UIFont(name: "Poppins-Bold", size: Layer.screenTitleFontSize.rawValue)
        label.textColor = .mainTextColor
        label.sizeToFit()
        return label
    }()
    
    private let deleteButton = FloatingActionButton(icon: UIImage(systemName: "trash"),
                                                    backgroundColor: .systemRed)
    
    // MARK: - Properties
    private var viewModel: SleepViewModelProtocol
    private var sleepImage: UIImage
    private var sleepTextColor: UIColor
    private var sleepBackgroundColor: UIColor
    var selectedDate: Date?
    var onSave: ((Date) -> Void)?
    var onDelete: (() -> Void)?
    
    // MARK: - Initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setupUI()
    }
    
    init(viewModel: SleepViewModelProtocol) {
        self.viewModel = viewModel
        
        sleepImage = UIImage(systemName: Constant.unownedImage.rawValue) ?? .remove
        sleepTextColor = .mainTextColor
        sleepBackgroundColor = .athensGray
        
        super.init(nibName: nil, bundle: nil)
        sleepCell.viewModel = viewModel
        setSleep(sleep: viewModel.sleep, number: viewModel.sleepNumber)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func setSleep(sleep: Sleep? = nil, number: Int?) {
        guard let sleep else { return }
        
        startSleepDatePicker.date = sleep.startDate
        endSleepDatePicker.date = sleep.endDate
        sleepCell.setSleep(sleep: sleep)
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        navigationItem.titleView = titleLabel
        view.backgroundColor = .athensGray
        view.addSubviews([startDateLabel,
                          endDateLabel,
                          startSleepDatePicker,
                          endSleepDatePicker,
                          sleepCell,
                          deleteButton])
        setupConstraints()
        setupBars()
        setupDatePicker()
        addTargets()
    }
    
    private func configure() {
        let isNew = viewModel.sleep == nil
        titleLabel.text = (isNew ? Constant.add : Constant.edit).rawValue.uppercased()
        deleteButton.isHidden = isNew ? true : false
        
        if isNew {
            let defaultSleep = Sleep(id: UUID(), startDate: selectedDate ?? .now,
                                     endDate: selectedDate ?? .now)
            viewModel.sleep = defaultSleep
            setSleep(sleep: defaultSleep, number: viewModel.sleepNumber)
        }
    }
    
    private func setupConstraints() {
        sleepCell.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(80)
        }
        
        startDateLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().offset(20)
            $0.top.equalTo(sleepCell.snp.bottom).offset(30)
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
        
        deleteButton.snp.makeConstraints {
            $0.height.width.equalTo(Layer.actionButtonSize.rawValue)
            $0.leading.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
    }
    
    private func setupBars() {
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save,
                                         target: self,
                                         action: #selector(saveButtonTapped))
        let trashButton = UIBarButtonItem(barButtonSystemItem: .trash,
                                          target: self,
                                          action: #selector(deleteButtonTapped))
        let spacing = UIBarButtonItem(systemItem: .flexibleSpace)
        
        navigationItem.rightBarButtonItem = saveButton
        setToolbarItems([trashButton, spacing], animated: true)
        saveButton.isEnabled = true
        trashButton.isHidden = viewModel.isNewSleep
    }
    
    private func addTargets() {
        deleteButton.button.addTarget(self,
                                      action: #selector(deleteButtonTapped),
                                      for: .touchUpInside)
    }
    
    @objc
    private func saveButtonTapped() {
        let startDate = startSleepDatePicker.date
        let endDate = endSleepDatePicker.date
        viewModel.save(with: startDate, and: endDate)
        onSave?(startDate)
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func deleteButtonTapped() {
        viewModel.delete()
        onDelete?()
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
        let updatedSleep = Sleep(
            id: viewModel.sleep?.id ?? UUID(),
            startDate: startSleepDatePicker.date,
            endDate: endSleepDatePicker.date
        )
        setSleep(sleep: updatedSleep, number: viewModel.sleepNumber)
    }
}
