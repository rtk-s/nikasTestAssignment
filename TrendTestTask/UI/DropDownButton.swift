//
//  DropDownButton.swift
//  TrendTestTask
//
//  Created by Nikolay on 14/04/2019.
//  Copyright © 2019 Nikolay. All rights reserved.
//

import UIKit

protocol DropDownProtocol: class {
    func dropDownPressed(priceModel: DropDownPriceModel)
}

protocol TransferDataToVCDelegate: class {
    func dataFromDropDownMenu(price: Int, direction: DropDownButton.Direction)
}


class DropDownButton: UIButton, DropDownProtocol {
    var defaultTitle: String = ""
    var isOpen = false
    
    enum Direction {
        case from, to
    }

    var direction: Direction!
    var dropView = DropDownView()
    var height = NSLayoutConstraint()
    weak var transferDelegate: TransferDataToVCDelegate!
    
    
    func dropDownPressed(priceModel: DropDownPriceModel) {
        
        transferDelegate.dataFromDropDownMenu(price: priceModel.price, direction: direction)
        
        if priceModel.title == "Сбросить" {
            self.setTitle(defaultTitle, for: .normal)
            self.dismissDropDown()
        } else {
            self.setTitle(priceModel.title, for: .normal)
            self.dismissDropDown()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        self.imageView?.contentMode = .scaleAspectFit
        self.imageEdgeInsets = UIEdgeInsets(top: 5, left: 160, bottom: 0, right: 0)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0)
        self.setTitleColor(.gray, for: .normal)
        
        dropView = DropDownView()
        dropView.delegate = self
        dropView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func didMoveToSuperview() {
        self.superview?.addSubview(dropView)
        self.superview?.bringSubviewToFront(dropView)
        
        height = dropView.heightAnchor.constraint(equalToConstant: 0)
        dropView.tableView.separatorStyle = .none
        addBorders()
    }
    
    func addBorders() {
        dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        dropView.layer.shadowColor = UIColor.black.cgColor
        dropView.layer.shadowOffset = CGSize(width: 0, height: 0)
        dropView.layer.shadowRadius = 0.5
        dropView.layer.shadowOpacity = 1
        dropView.clipsToBounds = false
        dropView.layer.masksToBounds = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isOpen == false {
            isOpen = true
            NSLayoutConstraint.deactivate([self.height])
            
            if self.dropView.tableView.contentSize.height > 150 {
                self.height.constant = 150
            } else {
                self.height.constant = self.dropView.tableView.contentSize.height
            }
            
            NSLayoutConstraint.activate([self.height])
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.dropView.layoutIfNeeded()
                self.dropView.center.y += self.dropView.frame.height / 2
            }, completion: nil)
            
        } else {
            isOpen = false
            
            NSLayoutConstraint.deactivate([self.height])
            self.height.constant = 0
            NSLayoutConstraint.activate([self.height])
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.dropView.center.y -= self.dropView.frame.height / 2
                self.dropView.layoutIfNeeded()
            }, completion: nil)
            
        }
    }
    
    func dismissDropDown() {
        isOpen = false
        NSLayoutConstraint.deactivate([self.height])
        self.height.constant = 0
        NSLayoutConstraint.activate([self.height])
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.dropView.center.y -= self.dropView.frame.height / 2
            self.dropView.layoutIfNeeded()
        }, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


