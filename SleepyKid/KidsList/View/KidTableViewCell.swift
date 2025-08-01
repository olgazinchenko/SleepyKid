//
//  KidTableViewCell.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 26/04/2024.
//

import UIKit
import SnapKit

final class KidTableViewCell: UITableViewCell {
    // MARK: - GUI Variables
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = UIConstants.Layer.mainCornerRadius
        return view
    }()
    
    private let avatarView: UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = UIConstants.Layer.mainCornerRadius
        view.image = UIImage(named: Constant.appIcon.rawValue)
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Medium", size: UIConstants.FontSize.labelLarge)
        label.textColor = .mainTextColor
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    private let ageLabel: UILabel = {
        let label = UILabel()
        label.tintColor = .mainTextColor
        label.font = UIFont(name: "Poppins-Medium", size: UIConstants.FontSize.labelLarge)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()
    
    // MARK: - Initializations
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func setKid(name: String, age: String) {
        nameLabel.text = name
        ageLabel.text = age
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        addSubview(containerView)
        containerView.addSubviews([avatarView, nameLabel, ageLabel])
        
        backgroundColor = .athensGray
        containerView.backgroundColor = .white
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints{
            $0.verticalEdges.equalToSuperview().inset(5)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(80)
        }
        
        avatarView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(50)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(avatarView.snp.trailing).offset(15)
            $0.verticalEdges.equalToSuperview().inset(5)
            $0.trailing.equalTo(ageLabel.snp.leading).offset(-15)
        }
        
        ageLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(15)
            $0.verticalEdges.equalToSuperview().inset(5)
        }
    }
}
