//
//  CollectionViewCell.swift
//  GameOfLife
//
//  Created by John Kouris on 8/19/20.
//  Copyright © 2020 John Kouris. All rights reserved.
//

import UIKit

class CollectionViewCell:  UICollectionViewCell {
    static let reuseID = "CollectionViewCell"
    let squareView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureWithState(_ isAlive: Bool) {
        self.squareView.backgroundColor = isAlive ? UIColor.blue : UIColor.lightGray
    }
    
    private func configure() {
        squareView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(squareView)
        squareView.layer.cornerRadius = 5
        
        NSLayoutConstraint.activate([
            squareView.topAnchor.constraint(equalTo: contentView.topAnchor),
            squareView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            squareView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            squareView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
}
