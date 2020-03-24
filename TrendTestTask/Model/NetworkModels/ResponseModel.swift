//
//  BuilderModel.swift
//  TrendTestTask
//
//  Created by Nikolay on 11/04/2019.
//  Copyright © 2019 Nikolay. All rights reserved.
//

import Foundation

struct ResponseModel: Codable {
    var image: String = ""
    var buildingName: String = ""
    var builderName: String = ""
    var areaName: String = ""
    var subwayName: String = ""
    var subwayColor: String = ""
    var subwayTime: Int = 0
    var deadline: String = ""
    var apartmentsCount: Int = 0
    var minPrices: [MinPriceModel] = []
    var travelType: String = ""
}
