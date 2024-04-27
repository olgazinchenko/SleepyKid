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
        view.backgroundColor = .lightBlue
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private let avatarView: UIImageView = {
        let view = UIImageView()
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .black
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
    func setSleep(startTime: String) {
        nameLabel.text = startTime
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        addSubview(containerView)
        containerView.addSubviews([avatarView, nameLabel])
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints{
            $0.verticalEdges.equalToSuperview().inset(5)
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.height.equalTo(80)
        }
        
        avatarView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.height.width.equalTo(50)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(avatarView.snp.trailing).offset(20)
            $0.verticalEdges.equalToSuperview().inset(5)
        }
    }
}

