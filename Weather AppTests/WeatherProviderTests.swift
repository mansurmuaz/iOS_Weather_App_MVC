//
//  Weather_AppTests.swift
//  Weather AppTests
//
//  Created by Mansur Muaz  Ekici on 3.07.2018.
//  Copyright © 2018 Adesso. All rights reserved.
//

import XCTest
@testable import Weather_App

class WeatherProviderTests: XCTestCase {

    let networkServiceMock = NetworkServiceMock.sharedInstance

    func testGetWeatherWithOneDayCount_CallsGetOneDayWeather() {

        let oneDayExpectation = self.expectation(description: "Getting data from weather provider for 1 day.")

        let weatherProvider: WeatherProviderProtocol = WeatherProvider(networkService: self.networkServiceMock)
        weatherProvider.getWeather(dayCount: .one, lat: 41, lon: 29) { (_) in
            XCTAssertTrue(self.networkServiceMock.getOneDayWeatherCalled)
            XCTAssertEqual(self.networkServiceMock.lat, 41)
            XCTAssertEqual(self.networkServiceMock.lon, 29)
            oneDayExpectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testGetWeatherWithFiveDaysCount_CallsGetFiveDaysWeather() {

        let fiveDaysExpectation = self.expectation(description: "Getting data from weather provider for 5 days.")

        let weatherProvider: WeatherProviderProtocol = WeatherProvider(networkService: self.networkServiceMock)
        weatherProvider.getWeather(dayCount: .five, lat: 41, lon: 29) { (_) in
            XCTAssertTrue(self.networkServiceMock.getFiveDaysWeatherCalled)
            XCTAssertEqual(self.networkServiceMock.lat, 41)
            XCTAssertEqual(self.networkServiceMock.lon, 29)
            fiveDaysExpectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
}
