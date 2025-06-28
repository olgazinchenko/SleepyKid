//
//  DateTimelineHeaderView.swift
//  SleepyKid
//
//  Created by ozinchenko.dev on 26/06/2025.
//

import UIKit

protocol DateTimelineHeaderViewDelegate: AnyObject {
    func didSelectDate(_ date: Date)
}

final class DateTimelineHeaderView: UIView {
    // MARK: - GUI Variables
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        return collectionView
    }()
    
    // MARK: - Properties
    private var dates: [Date] = []
    weak var delegate: DateTimelineHeaderViewDelegate?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    init(startDate: Date, frame: CGRect) {
        self.dates = DateHelper.shared.getDates(from: startDate)
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func setupUI() {
        collectionView.backgroundColor = .clear
        addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DateCollectionViewCell.self,
                                forCellWithReuseIdentifier: "DateCollectionViewCell")
        collectionView.showsHorizontalScrollIndicator = false
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.verticalEdges.equalToSuperview()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension DateTimelineHeaderView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        dates.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCollectionViewCell",
                                                            for: indexPath) as? DateCollectionViewCell
        else { return UICollectionViewCell() }
        let date = dates[indexPath.item]
        cell.configure(with: date)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension DateTimelineHeaderView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let date = dates[indexPath.item]
        delegate?.didSelectDate(date)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension DateTimelineHeaderView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 60)
    }
}
