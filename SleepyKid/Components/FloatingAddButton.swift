//
//  FloatingAddButton.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 30/07/2025.
//

import UIKit
import SnapKit

final class FloatingAddButton: UIView {
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
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        addSubview(button)
        setupConstraints()
    }
    
    private func setupConstraints() {
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
