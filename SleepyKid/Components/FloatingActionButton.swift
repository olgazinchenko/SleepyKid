//
//  FloatingAddButton.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 30/07/2025.
//

import UIKit
import SnapKit

final class FloatingActionButton: UIView {
    // MARK: - Public button
    let button = UIButton(type: .custom)

    // MARK: - Initialization
    init(
        icon: UIImage? = nil,
        title: String? = nil,
        backgroundColor: UIColor = .systemOrange,
        tintColor: UIColor = .white
    ) {
        super.init(frame: .zero)
        setupUI(
            icon: icon,
            title: title,
            backgroundColor: backgroundColor,
            tintColor: tintColor
        )
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupUI(icon: UIImage?,
                         title: String?,
                         backgroundColor: UIColor,
                         tintColor: UIColor) {
        button.setImage(nil, for: .normal)
        button.setTitle(nil, for: .normal)
        button.backgroundColor = backgroundColor
        button.tintColor = tintColor
        button.titleLabel?.font = UIFont(name: "Poppins-Regular",
                                         size: UIConstants.Button.actionTitleSize)
        button.layer.cornerRadius = UIConstants.Button.actionCornerRadius
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = UIConstants.Button.actionShadowRadius
        button.accessibilityLabel = nil
        
        if let icon = icon {
            button.setImage(icon, for: .normal)
        } else if let title = title {
            button.setTitle(title, for: .normal)
            button.setTitleColor(tintColor, for: .normal)
        }
        
        addSubview(button)
    }
    
    private func setupConstraints() {
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    // MARK: - Public API
    func prepareForReuse() {
        button.setImage(nil, for: .normal)
        button.setTitle(nil, for: .normal)
        button.backgroundColor = .clear
        button.tintColor = .clear
        button.removeTarget(nil, action: nil, for: .allEvents)
        button.accessibilityLabel = nil
        button.layer.shadowOpacity = 0
    }
}
