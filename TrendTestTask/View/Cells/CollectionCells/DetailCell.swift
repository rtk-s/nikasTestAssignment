//
//  DetailCell.swift
//  TrendTestTask
//
//  Created by Nikolay on 11/04/2019.
//  Copyright © 2019 Nikolay. All rights reserved.
//

import UIKit

enum TravelType: String {
    case walk = "пешком"
    case bus = "транспортом"
}

class DetailCell: UICollectionViewCell {

    @IBOutlet weak var buldingNameLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var buildingImage: UIImageView!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var builderLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var subwayLabel: UILabel!
    @IBOutlet weak var tableView: PricingTableView!
    @IBOutlet weak var metroIconImage: UIImageView!
    @IBOutlet weak var travelIconImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 2
        
        let originalImage = metroIconImage.image
        let tintedImage = originalImage?.withRenderingMode(.alwaysTemplate)
        metroIconImage.image = tintedImage
    }
    

    internal func fillCell(with model: [ResponseModel], at indexPath: IndexPath) {
        builderLabel.text = model[indexPath.item].builderName
        buldingNameLabel.text = model[indexPath.item].buildingName
        deadlineLabel.text = model[indexPath.item].deadline
        areaLabel.text = model[indexPath.item].areaName
        builderLabel.text = model[indexPath.item].builderName
        timeLabel.text = "\(model[indexPath.item].subwayTime) мин."
        subwayLabel.text = model[indexPath.item].subwayName
        metroIconImage.tintColor = UIColor(hexString: model[indexPath.item].subwayColor)
        buildingImage.sd_setShowActivityIndicatorView(true)
        buildingImage.sd_setIndicatorStyle(.gray)
        buildingImage.sd_setImage(with: URL(string: model[indexPath.item].image), placeholderImage: UIImage(named: "gradient"))

        if TravelType.walk.rawValue == model[indexPath.item].travelType {
            travelIconImage.image = UIImage(named: "walk")
        } else {
            travelIconImage.image = UIImage(named: "busIcon")
        }

        tableView.responseModel = model[indexPath.item]
        tableView.reloadData()
    }

    internal func animateFade() {
        UIView.animate(withDuration: 1) {
            self.alpha = 1
        }
    }
}

