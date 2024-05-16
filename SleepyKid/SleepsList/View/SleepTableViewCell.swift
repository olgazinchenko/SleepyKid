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
        view.image = UIImage(systemName: Text.timeBadge.rawValue)
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
        
        let startDate = viewModel.getTrimmed(date: sleep.startDate)
        let endDate = viewModel.getTrimmed(date: sleep.endDate)
        let sleepIntervalText = viewModel.getSleepInterval(from: startDate,
                                                           to: endDate)
        let sleepType = viewModel.getSleepType(from: startDate,
                                               to: endDate)
        let formattedStartTime = viewModel.getFormatted(date: startDate)
        let formattedEndTime = viewModel.getFormatted(date: endDate)
        
        timeLabel.text = "\(formattedStartTime) - \(formattedEndTime)"
        sleepDurationLabel.text = sleepIntervalText
        countImageView.image = UIImage(systemName: "\(count + 1).circle")
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
    
    private func updateUI(for sleepType: SleepType) {
        let dayImage = UIImage(systemName: Text.dayImage.rawValue)
        let nightImage = UIImage(systemName: Text.nightImage.rawValue)
        let unownedImage = UIImage(systemName: Text.unownedImage.rawValue)
        
        switch sleepType {
        case .day:
            iconView.image = dayImage
            iconView.tintColor = .mainYellow
            countImageView.tintColor = .mainYellow
            containerView.backgroundColor = .lightYellow
        case .night:
            iconView.image = nightImage
            iconView.tintColor = .mainBlue
            countImageView.tintColor = .mainBlue
            containerView.backgroundColor = .mainPurple
        case .unowned:
            iconView.image = unownedImage
            iconView.tintColor = .systemGray
            countImageView.tintColor = .systemGray
            containerView.backgroundColor = .white
        }
    }
}

