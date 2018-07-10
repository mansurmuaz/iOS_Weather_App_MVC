//
//  WeatherModelTests.swift
//  Weather AppTests
//
//  Created by Mansur Muaz  Ekici on 10.07.2018.
//  Copyright © 2018 Adesso. All rights reserved.
//

import XCTest
@testable import Weather_App
import SwiftyJSON

class WeatherModelTests: XCTestCase {
    
    var expectedResult = JSON()
    let jsonString = "{\"coord\":{\"lon\":-122.09,\"lat\":37.39},\n\"sys\":{\"type\":3,\"id\":168940,\"message\":0.0297,\"country\":\"US\",\"sunrise\":1427723751,\"sunset\":1427768967},\n\"weather\":[{\"id\":800,\"main\":\"Clear\",\"description\":\"Sky is Clear\",\"icon\":\"01n\"}],\n\"base\":\"stations\",\n\"main\":{\"temp\":285.68,\"humidity\":74,\"pressure\":1016.8,\"temp_min\":284.82,\"temp_max\":286.48},\n\"wind\":{\"speed\":0.96,\"deg\":285.001},\n\"clouds\":{\"all\":0},\n\"dt\":1427700245,\n\"id\":0,\n\"name\":\"Mountain View\",\n\"cod\":200}"
    
    override func setUp() {
        super.setUp()
        expectedResult = JSON(parseJSON: self.jsonString)
    }
    
    func testWeatherModelWithStaticJsonString_ReturnsWeatherModel(){
        let weatherModel = WeatherModel(json: expectedResult)
        
        XCTAssertEqual(weatherModel.name, "Mountain View")
        XCTAssertEqual(weatherModel.degree, Int(285.68))
        XCTAssertEqual(weatherModel.weather, "Clear")
        XCTAssertEqual(weatherModel.description, "Sky is Clear")
        XCTAssertEqual(weatherModel.wind, 0.96)
        XCTAssertEqual(weatherModel.humidity, 74)
        XCTAssertEqual(weatherModel.date, "")
        XCTAssertEqual(weatherModel.unit, "ºC")
        XCTAssertEqual(weatherModel.image,  #imageLiteral(resourceName: "clear sky night"))
    }
    
}
