//
//  EmptyStateLabel.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 31/07/2025.
//

import UIKit
import SnapKit

final class EmptyStateLabel: UILabel {
    // MARK: - Initialization
    init(message: String) {
        super.init(frame: .zero)
        setupUI(message: message)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupUI(message: String) {
        text = message
        textColor = .systemOrange
        font = UIFont(name: "Poppins-Regular", size: UIConstants.FontSize.labelLarge)
        textAlignment = .center
        numberOfLines = 3
        isHidden = true
    }
}
