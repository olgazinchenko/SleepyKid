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
        view.layer.cornerRadius = Layer.mainCornerRadius.rawValue
        view.backgroundColor = .white
        return view
    }()
    
    private let iconView: UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = Layer.mainCornerRadius.rawValue
        return view
    }()
    
    private var timeImageView: UIImageView = {
        let view = UIImageView()
        view.tintColor = .mainTextColor
        return view
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Regular", size: Layer.labelFontSizeLarge.rawValue)
        label.tintColor = .mainTextColor
        return label
    }()
    
    private let sleepDurationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Medium", size: Layer.labelFontSizeSmall.rawValue)
        label.tintColor = .mainTextColor
        return label
    }()
    
    private let countImageView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    // MARK: - Properties
    var viewModel: SleepViewModelProtocol?
    
    // MARK: - Initializations
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func setSleep(sleep: Sleep) {
        guard let viewModel else { return }
        
        let timeIntervalText = viewModel.getTimeIntervalText(for: sleep.startDate,
                                                             and: sleep.endDate)
        let sleepIntervalText = viewModel.getSleepInterval(from: sleep.startDate,
                                                           to: sleep.endDate)
        let sleepType = viewModel.getSleepType(from: sleep.startDate,
                                               to: sleep.endDate)
        let sleepNumber = viewModel.sleepNumber
        timeLabel.text = timeIntervalText
        sleepDurationLabel.text = sleepIntervalText
        countImageView.image = sleepNumber.map { UIImage(systemName: "\($0 + 1).circle") ?? .add }
        countImageView.isHidden = (countImageView.image == nil)
        updateUI(for: sleepType)
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        addSubview(containerView)
        containerView.addSubviews([iconView, 
                                   timeLabel,
                                   sleepDurationLabel,
                                   timeImageView,
                                   countImageView])
        
        backgroundColor = .athensGray
        containerView.backgroundColor = .white
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints{
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(80)
        }
        
        iconView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(50)
        }
        
        timeLabel.snp.makeConstraints {
            $0.leading.equalTo(iconView.snp.trailing).offset(15)
            $0.centerY.equalToSuperview().offset(-10)
        }
        
        timeImageView.snp.makeConstraints {
            $0.leading.equalTo(iconView.snp.trailing).offset(15)
            $0.top.equalTo(timeLabel.snp.bottom).offset(5)
            $0.height.width.equalTo(16)
        }
        
        sleepDurationLabel.snp.makeConstraints {
            $0.leading.equalTo(timeImageView.snp.trailing).offset(5)
            $0.centerY.equalTo(timeImageView)
        }
        
        countImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(30)
        }
    }
    
    private func updateUI(for sleepType: SleepType) {
        let dayImage = UIImage(named: Constant.dayImage.rawValue)
        let nightImage = UIImage(named: Constant.nightImage.rawValue)
        let unownedImage = UIImage(named: Constant.unownedImage.rawValue)
        let sleepImage = UIImage(systemName: Constant.timeBadge.rawValue)
        
        switch sleepType {
        case .day:
            iconView.image = dayImage
            iconView.tintColor = .mainYellow
            countImageView.tintColor = .mainYellow
            timeImageView.image = sleepImage
            timeImageView.tintColor = .mainYellow
            sleepDurationLabel.textColor = .mainYellow
        case .night:
            iconView.image = nightImage
            iconView.tintColor = .mainBlue
            countImageView.tintColor = .mainBlue
            timeImageView.image = sleepImage
            timeImageView.tintColor = .mainBlue
            sleepDurationLabel.textColor = .mainBlue
        case .unowned:
            iconView.image = unownedImage
            iconView.tintColor = .systemGray
            countImageView.tintColor = .systemGray
            timeImageView.image = sleepImage
            timeImageView.tintColor = .systemGray
            sleepDurationLabel.textColor = .systemGray
        }
    }
}

