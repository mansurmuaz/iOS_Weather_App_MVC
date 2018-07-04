//
//  WeatherModel.swift
//  Weather App
//
//  Created by Mansur Muaz  Ekici on 3.07.2018.
//  Copyright © 2018 Adesso. All rights reserved.
//

import Foundation
import SwiftyJSON

class WeatherModel {
    
    var region: String
    var degree: Int
    var weather: String
    var description: String
    var unit: String

    init(json: JSON) {
        self.region = json["name"].stringValue
        self.degree = Int(json["main"]["temp"].doubleValue)
        self.weather = json["weather"][0]["main"].stringValue
        self.description = json["weather"][0]["description"].stringValue
        self.unit = "ºC"
    }
    
}
