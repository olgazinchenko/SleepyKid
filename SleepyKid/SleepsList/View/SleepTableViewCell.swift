//
//  SleepTableViewCell.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 27/04/2024.
//

import UIKit
import SnapKit

final class SleepTableViewCell: UITableViewCell {
    // MARK: - GUI Variables
    private let containerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = Layer.mainBoarderWidth.rawValue
        view.layer.cornerRadius = Layer.mainCornerRadius.rawValue
        view.layer.borderColor = UIColor.black.cgColor
        return view
    }()
    
    private let iconView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    private let timeImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: Text.timeImageName.rawValue)
        view.tintColor = .mainTextColor
        return view
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.tintColor = .mainTextColor
        return label
    }()
    
    private let sleepDurationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.tintColor = .mainTextColor
        return label
    }()
    
    private let countImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    // MARK: - Initializations
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Properties
    var viewModel: SleepViewModelProtocol?
    
    // MARK: - Methods
    func setSleep(sleep: Sleep, count: Int) {
        guard let viewModel = viewModel else { return }
        
        let sleepIntervalText = viewModel.getSleepInterval(from: sleep.startDate,
                                                           to: sleep.endDate)
        let sleepType = viewModel.getSleepType(from: sleep.startDate,
                                               to: sleep.endDate)
        let formattedStartTime = viewModel.getFormatted(date: sleep.startDate)
        let formattedEndTime = viewModel.getFormatted(date: sleep.endDate)
        
        timeLabel.text = "\(formattedStartTime) - \(formattedEndTime)"
        sleepDurationLabel.text = sleepIntervalText
        countImageView.image = UIImage(systemName: "\(count + 1).circle")
        updateUIFor(sleepType)
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        addSubview(containerView)
        containerView.addSubviews([iconView, 
                                   timeLabel,
                                   sleepDurationLabel,
                                   timeImageView,
                                   countImageView])
        setupConstraints()
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints{
            $0.verticalEdges.equalToSuperview().inset(5)
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.height.equalTo(100)
        }
        
        iconView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(50)
        }
        
        timeLabel.snp.makeConstraints {
            $0.leading.equalTo(iconView.snp.trailing).offset(20)
            $0.centerY.equalToSuperview().offset(-10)
        }
        
        timeImageView.snp.makeConstraints {
            $0.leading.equalTo(iconView.snp.trailing).offset(20)
            $0.top.equalTo(timeLabel.snp.bottom).offset(5)
            $0.height.width.equalTo(16)
        }
        
        sleepDurationLabel.snp.makeConstraints {
            $0.leading.equalTo(timeImageView.snp.trailing).offset(5)
            $0.centerY.equalTo(timeImageView)
        }
        
        countImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(30)
        }
    }
    
    private func updateUIFor(_ sleepType: Sleep.SleepType) {
        let sunImage = UIImage(systemName: Text.sleepDayImageName.rawValue)
        let moonImage = UIImage(systemName: Text.sleepNightImageName.rawValue)
        iconView.image = (sleepType == .day) ? sunImage : moonImage
        iconView.tintColor = (sleepType == .day) ? .mainYellow : .mainBlue
        countImageView.tintColor = (sleepType == .day) ? .mainYellow : .mainBlue
        containerView.backgroundColor = (sleepType == .day) ? .lightYellow : .mainPurple
    }
}

