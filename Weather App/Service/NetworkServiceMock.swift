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
    var getWeatherCalled = false
    var lat = 0
    var lon = 0
    
    func getWeather(lat: Double, lon: Double, completion: @escaping (JSON) -> ()) {
        self.getWeatherCalled = true
        self.lat = Int(lat)
        self.lon = Int(lon)
        completion(JSON())
    }
    
    func getFiveDaysWeather(lat: Double, lon: Double, completion: @escaping (JSON) -> ()) {
        self.getWeatherCalled = true
        self.lat = Int(lat)
        self.lon = Int(lon)
        completion(JSON())
    }
}
