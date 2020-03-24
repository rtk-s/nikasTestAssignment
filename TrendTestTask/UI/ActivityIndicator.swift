//
//  ActivityIndicator.swift
//  TrendTestTask
//
//  Created by Nikolay on 14/04/2019.
//  Copyright © 2019 Nikolay. All rights reserved.
//

import Foundation
import UIKit

class ActivityIndicator {
    
    let container: UIView = UIView()
    let activityView = UIActivityIndicatorView(style: .whiteLarge)
    
    func showActivityIndicator(uiView: UIView) {
        container.frame = CGRect(x: 0, y: 0, width: uiView.frame.size.width, height: uiView.frame.size.height + 80)
        container.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        
        activityView.center = uiView.center
        activityView.startAnimating()
        
        container.addSubview(activityView)
        uiView.addSubview(container)
        activityView.startAnimating()
    }
    
    func hideActivityIndicator(uiView: UIView) {
        activityView.stopAnimating()
        container.removeFromSuperview()
    }
}
