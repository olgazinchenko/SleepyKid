//
//  DateCollectionViewCell.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 26/06/2025.
//

import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    // MARK: - GUI Variables
    private let label = UILabel()
    
    // MARK: - Initializations
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        label.textAlignment = .center
        label.frame = contentView.bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray4.cgColor
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Methods
    func configure(with date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        label.text = formatter.string(from: date)
    }
}
