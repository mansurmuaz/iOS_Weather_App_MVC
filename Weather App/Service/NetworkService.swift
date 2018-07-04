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

struct NetworkService {
    
    static let sharedInstance = NetworkService()
    
    func getWeather(lat: Double, lon: Double, completion: @escaping (JSON) -> ()) {
        
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&units=metric&appid=5393eb001d6f5b930af18785a01fa6f3"
        
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
