//
//  UnderscoreExtension.swift
//  TrendTestTask
//
//  Created by Nikolay on 13/04/2019.
//  Copyright © 2019 Nikolay. All rights reserved.
//
import UIKit


enum ViewBorder: String {
    case left, right, top, bottom
}

extension UIView {
    func addStroke(border: ViewBorder, color: UIColor, width: CGFloat) {
        let borderLayer = CALayer()
        borderLayer.backgroundColor = color.cgColor
        borderLayer.name = border.rawValue
        switch border {
        case .left:
            borderLayer.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        case .right:
            borderLayer.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        case .top:
            borderLayer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        case .bottom:
            borderLayer.frame = CGRect(x: 0, y: self.frame.size.height - width - 2, width: self.frame.size.width, height: width)
        }
        self.layer.addSublayer(borderLayer)
    }
    
    func remove(border: ViewBorder) {
        guard let sublayers = self.layer.sublayers else { return }
        var layerForRemove: CALayer?
        for layer in sublayers {
            if layer.name == border.rawValue {
                layerForRemove = layer
            }
        }
        if let layer = layerForRemove {
            layer.removeFromSuperlayer()
        }
    }
    
}
