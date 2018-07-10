//
//  NetworkServiceMock.swift
//  Weather App
//
//  Created by Mansur Muaz  Ekici on 9.07.2018.
//  Copyright © 2018 Adesso. All rights reserved.
//

import Foundation
import SwiftyJSON

class NetworkServiceMock: NetworkServiceProtocol {
    
    static let sharedInstance = NetworkServiceMock()
    var getOneDayWeatherCalled = false
    var getFiveDaysWeatherCalled = false
    var lat = 0
    var lon = 0
    
    let jsonString = "{\"list\":[{\"main\":{\"grnd_level\":1004.45,\"temp_min\":15.84,\"temp_max\":16.370000000000001,\"temp\":15.84,\"sea_level\":1028.6500000000001,\"pressure\":1004.45,\"humidity\":57,\"temp_kf\":-0.53000000000000003},\"clouds\":{\"all\":0},\"weather\":[{\"main\":\"Clear\",\"icon\":\"01n\",\"description\":\"clear sky\",\"id\":800}],\"dt_txt\":\"2018-07-10 12:00:00\",\"dt\":1531213200,\"sys\":{\"pod\":\"n\"},\"wind\":{\"deg\":261.50099999999998,\"speed\":1.3200000000000001}}],\"cod\":\"200\",\"cnt\":37,\"message\":0.0058999999999999999,\"city\":{\"name\":\"Burdell\",\"id\":5331874,\"coord\":{\"lat\":38.158000000000001,\"lon\":-122.56529999999999},\"country\":\"US\"}}"
    
    func getWeather(lat: Double, lon: Double, completion: @escaping (JSON) -> ()) {
        self.getOneDayWeatherCalled = true
        self.lat = Int(lat)
        self.lon = Int(lon)
        completion(JSON())
    }
    
    func getFiveDaysWeather(lat: Double, lon: Double, completion: @escaping (JSON) -> ()) {
        self.getFiveDaysWeatherCalled = true
        self.lat = Int(lat)
        self.lon = Int(lon)
        completion(JSON(parseJSON: jsonString))
    }
}
