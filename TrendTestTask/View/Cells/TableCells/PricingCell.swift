//
//  PricingCell.swift
//  TrendTestTask
//
//  Created by Nikolay on 11/04/2019.
//  Copyright © 2019 Nikolay. All rights reserved.
//

import UIKit

class PricingCell: UITableViewCell {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var roomsCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}
