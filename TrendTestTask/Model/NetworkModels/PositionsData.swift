//
//  PositionsData.swift
//  TrendTestTask
//
//  Created by Nikolay on 14/04/2019.
//  Copyright © 2019 Nikolay. All rights reserved.
//

import Foundation

struct PositionsData: Codable {
    var models: [ResponseModel] = []
    var amount: Int = 0
}
