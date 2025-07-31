//
//  FloatingAddButton.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 30/07/2025.
//

import UIKit
import SnapKit

final class FloatingActionButton: UIView {
    // MARK: - GUI Variables
    let button: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .orange
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Poppins-Regular",
                                         size: Layer.actionButtonTitleSize.rawValue)
        button.layer.cornerRadius = Layer.actionButtonCornerRadius.rawValue
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = Layer.actionButtonssHadowRadius.rawValue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Initialization
    init(icon: UIImage? = nil,
         title: String? = nil,
         backgroundColor: UIColor = .orange,
         tintColor: UIColor = .white) {
        
        super.init(frame: .zero)
        prepareForReuse()
        setupUI(icon: icon,
                title: title,
                backgroundColor: backgroundColor,
                tintColor: tintColor)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI(icon: UIImage?,
                         title: String?,
                         backgroundColor: UIColor,
                         tintColor: UIColor) {
        if let icon = icon {
            button.setImage(icon, for: .normal)
            button.imageView?.tintColor = .white
        } else if let title = title {
            button.setTitle(title, for: .normal)
            button.setTitleColor(tintColor, for: .normal)
        }
        addSubview(button)
        setupConstraints()
    }
    
    private func prepareForReuse() {
        button.setImage(nil, for: .normal)
        button.setTitle(nil, for: .normal)
        button.backgroundColor = .clear
        button.tintColor = .clear
        button.removeTarget(nil, action: nil, for: .allEvents)
        button.accessibilityLabel = nil
        button.layer.shadowOpacity = 0
    }
    
    private func setupConstraints() {
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
