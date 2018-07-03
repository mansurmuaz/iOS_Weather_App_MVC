//
//  WeatherModel.swift
//  Weather App
//
//  Created by Mansur Muaz  Ekici on 3.07.2018.
//  Copyright © 2018 Adesso. All rights reserved.
//

import Foundation

class WeatherModel {
    
    var region: String
    var degree: Int
    var weather: String
    var description: String
    var unit: String

    init(region: String, degree: Int, weather: String, description: String, unit: String) {
        self.region = region
        self.degree = degree
        self.weather = weather
        self.description = description
        self.unit = unit
    }
    
}
