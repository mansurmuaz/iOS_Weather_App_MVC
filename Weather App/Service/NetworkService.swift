//
//  NetworkService.swift
//  Weather App
//
//  Created by Mansur Muaz  Ekici on 3.07.2018.
//  Copyright © 2018 Adesso. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol NetworkServiceProtocol {
    func getWeather(lat: Double, lon: Double, completion: @escaping (JSON) -> ())
    func getFiveDaysWeather(lat: Double, lon: Double, completion: @escaping (JSON) -> ())
}

class NetworkService:NetworkServiceProtocol {
    
    static let sharedInstance = NetworkService()
    
    let baseURL = "https://api.openweathermap.org/data/2.5"
    let apiKey = "5393eb001d6f5b930af18785a01fa6f3"
    
    func getWeather(lat: Double, lon: Double, completion: @escaping (JSON) -> ()) {
        let url = "\(baseURL)/weather?lat=\(lat)&lon=\(lon)&units=metric&appid=\(apiKey)"
        Alamofire.request(url).validate().responseJSON { response in
            switch response.result {
            case .success:
        
                let resultJSON = JSON(response.result.value!)
                completion(resultJSON)
                
            case .failure(let error):
                print(error)
            }
        }
    }
 
    func getFiveDaysWeather(lat: Double, lon: Double, completion: @escaping (JSON) -> ()) {
        let url = "\(baseURL)/forecast?lat=\(lat)&lon=\(lon)&units=metric&appid=\(apiKey)"
        Alamofire.request(url).validate().responseJSON { response in
            switch response.result {
            case .success:
                
                let resultJSON = JSON(response.result.value!)
                completion(resultJSON)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
