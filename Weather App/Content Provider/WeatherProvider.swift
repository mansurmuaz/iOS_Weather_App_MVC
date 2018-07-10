//
//  WeatherProvider.swift
//  Weather App
//
//  Created by Mansur Muaz  Ekici on 9.07.2018.
//  Copyright © 2018 Adesso. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol WeatherProviderProtocol {
    func getWeather(dayCount: dayCount, lat: Double, lon:Double, completion: @escaping (WeatherModel) -> ())
}

enum dayCount {
    case one
    case five
}

class WeatherProvider: WeatherProviderProtocol {
    
    let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func getWeather(dayCount: dayCount, lat: Double, lon: Double, completion: @escaping (WeatherModel) -> ()) {
        
        switch dayCount {
        case .one:
            networkService.getWeather(lat: lat, lon: lon) { (json) in
                completion(WeatherModel(json: json))
            }
        case .five:
            networkService.getFiveDaysWeather(lat: lat, lon: lon) { (json) in
                for weatherJSON in json["list"].arrayValue{
                    if weatherJSON["dt_txt"].stringValue.split(separator: " ")[1].starts(with: "12"){
                        completion(WeatherModel(json: weatherJSON))
                    }
                }
            }
        }
    }
}
