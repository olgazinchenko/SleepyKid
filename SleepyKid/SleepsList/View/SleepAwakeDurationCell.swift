//
//  SleepAwakeDurationCell.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 27/04/2024.
//

import UIKit
import SnapKit

final class SleepAwakeDurationCell: UITableViewCell {
    // MARK: - GUI Variables
    private let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let awakeIconView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: Constant.awakeImage.rawValue)
        view.tintColor = .mainTextColor
        return view
    }()
    
    private let awakeDurationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Poppins-Regular", size: 14)
        label.textColor = .mainTextColor
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
    func setAwakeDuration(_ duration: String) {
        awakeDurationLabel.text = duration
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        addSubview(containerView)
        containerView.addSubviews([awakeIconView, 
                                   awakeDurationLabel])
        
        backgroundColor = .athensGray
        containerView.backgroundColor = .athensGray
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints{
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        awakeDurationLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(15)
            $0.centerY.equalToSuperview()
        }
        
        awakeIconView.snp.makeConstraints {
            $0.trailing.equalTo(awakeDurationLabel.snp.leading).offset(-5)
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(20)
        }
    }
} 
