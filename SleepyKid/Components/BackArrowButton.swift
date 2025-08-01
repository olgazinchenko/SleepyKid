//
//  BackArrowButton.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 01/08/2025.
//

import UIKit

final class BackArrowButton: UIButton {
    
    init(size: CGFloat = 36,
         cornerRadius: CGFloat = 6,
         backgroundColor: UIColor = .clear,
         borderColor: UIColor = UIConstants.Button.color,
         tintColor: UIColor = UIConstants.Layer.mainLabelColor) {
        super.init(frame: .zero)
        
        // Icon
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .medium)
        setImage(UIImage(systemName: "arrow.left", withConfiguration: config), for: .normal)
        self.tintColor = tintColor
        
        // Shape & border
        self.backgroundColor = backgroundColor
        layer.cornerRadius = cornerRadius
        layer.borderWidth = 1
        layer.borderColor = borderColor.cgColor
        
        // No shadow (reference style is flat)
        layer.shadowOpacity = 0
        
        // Disable autoresizing mask
        translatesAutoresizingMaskIntoConstraints = false
        
        // Fixed size
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: size),
            heightAnchor.constraint(equalToConstant: size)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
