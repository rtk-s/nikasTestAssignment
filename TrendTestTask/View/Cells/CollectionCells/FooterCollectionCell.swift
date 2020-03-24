//
//  FooterCollectionCell.swift
//  TrendTestTask
//
//  Created by Nikolay on 18/04/2019.
//  Copyright © 2019 Nikolay. All rights reserved.
//

import UIKit

class FooterCollectionCell: UICollectionViewCell {
    
    let loadMoreButton: UIButton = UIButton(frame: CGRect(x: 0, y: 20, width: 40, height: 40))
    
    override func awakeFromNib() {
        super.awakeFromNib()

        uiConfigurationOfLoadMoreButton()
        makeContraintsForLoadMoreButton()
    }
    
    private func uiConfigurationOfLoadMoreButton() {
        loadMoreButton.setTitle("Загрузить ещё 10", for: .normal)
        loadMoreButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        loadMoreButton.setTitleColor(.black, for: .normal)
        
        loadMoreButton.layer.cornerRadius = 3
        loadMoreButton.layer.borderColor = UIColor.black.cgColor
        loadMoreButton.layer.borderWidth = 0.7
        contentView.addSubview(loadMoreButton)
    }
    
    private func makeContraintsForLoadMoreButton() {
        loadMoreButton.translatesAutoresizingMaskIntoConstraints = false
        loadMoreButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        loadMoreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        loadMoreButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        loadMoreButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        loadMoreButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
}
