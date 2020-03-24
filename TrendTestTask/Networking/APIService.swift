//
//  APIService.swift
//  TrendTestTask
//
//  Created by Nikolay on 13/04/2019.
//  Copyright © 2019 Nikolay. All rights reserved.
//


import Foundation
import Alamofire
import SwiftyJSON

typealias PositionsCompletion = (PositionsData) -> Void

enum SortType: String {
    case price
    case subway
    case region
}

class APIService {
    
    private let domain = URL(string: "http://api.trend-dev.ru/v3_1/blocks/search/?show_type=list")
    private let headers = ["Content-Type": "application/json"]
    
    func fetchInitialData(completion: @escaping PositionsCompletion) {
        fetchPositions(completion: completion)
    }
    
    func fetch(sortedBy sortType: SortType = SortType.price, withOffset offset: Int = 0, completion: @escaping PositionsCompletion) {
        fetchPositions(count: 10, offset: offset, sortType: sortType, completion: completion)
    }
    
    func fetch(sortedBy sortType: SortType = SortType.price, withOffset offset: Int = 0, priceFrom: Int = 0, priceTo: Int = 0, completion: @escaping PositionsCompletion) {
        fetchPositions(offset: offset, priceFrom: priceFrom, priceTo: priceTo, sortType: sortType, completion: completion)
    }
    
    private func fetchPositions(
        showType: String = "list",
        count: Int = 10,
        offset: Int = 0,
        cache: Bool = false,
        priceFrom: Int = 0,
        priceTo: Int = 0,
        sortType: SortType = SortType.price,
        completion: @escaping PositionsCompletion) {
        
        DispatchQueue.global(qos: .background).async {
            var parameters: [String: Any] = [:]
            parameters.updateValue(count, forKey: "count")
            parameters.updateValue(offset, forKey: "offset")
            parameters.updateValue(cache, forKey: "cache")
            parameters.updateValue(priceTo, forKey: "price_to")
            parameters.updateValue(priceFrom, forKey: "price_from")
            parameters.updateValue(sortType.rawValue, forKey: "sort")
            
            request(self.domain!, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: self.headers).responseJSON { response in
                if let data = response.result.value {
                    let buildingsInfoJSON: JSON = JSON(data)
                    
                    var tempArray = [ResponseModel]()
                    var amount = 0
                    
                    if let subJson = buildingsInfoJSON["data"]["results"].array {
                        
                        for items in subJson {
                            var model = ResponseModel()
                            model.builderName = items["builder"]["name"].stringValue
                            model.buildingName = items["name"].stringValue
                            model.deadline = items["deadline"].stringValue
                            model.areaName = items["region"]["name"].stringValue
                            model.subwayName = items["subways"][0]["name"].stringValue
                            model.subwayTime = items["subways"][0]["distance_timing"].intValue
                            model.subwayColor = items["subways"][0]["color"].stringValue
                            model.travelType = items["subways"][0]["distance_type"].stringValue
                            model.image = items["image"].stringValue
                            
                            let minPrices = items["min_prices"].arrayValue.map({
                                MinPriceModel(
                                    room: $0["room"].intValue,
                                    rooms: $0["rooms"].stringValue,
                                    minPrices: $0["price"].intValue
                                )
                            })
                            
                            let filteredMinPrices = minPrices.filter { $0.room != 100 }
                            model.minPrices = filteredMinPrices
                            tempArray.append(model)
                            
                        }
                    }
                    if let objectsCount = buildingsInfoJSON["data"]["apartmentsCount"].int {
                        amount = objectsCount
                    }
                    completion(PositionsData(models: tempArray, amount: amount))
                }
            }
        }
    }
}

