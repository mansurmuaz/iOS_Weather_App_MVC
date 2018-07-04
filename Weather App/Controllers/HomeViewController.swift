//
//  HomeViewController.swift
//  Weather App
//
//  Created by Mansur Muaz  Ekici on 3.07.2018.
//  Copyright © 2018 Adesso. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation

class HomeViewController: UIViewController {

    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    let networkService = NetworkService.sharedInstance
    let locationManager:CLLocationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.regionLabel.text = ""
        self.degreeLabel.text = ""
        self.weatherLabel.text = ""
        self.descriptionLabel.text = ""
        self.unitLabel.text = ""
        
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
            spinner.startAnimating()
        }
    }

}


extension HomeViewController: CLLocationManagerDelegate{
    
    // If we have been deined access give the user the option to change it
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
    }
    
    // Show the popup to the user if we have been deined access
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Background Location Access Disabled",
                                                message: "In order to display weather at your location, we need your location data!",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            let lon = location.coordinate.longitude
            let lat = location.coordinate.latitude
            
            locationManager.stopUpdatingLocation()
            
            networkService.getCurrentWeather(lat: Float(lat), lon: Float(lon)) { (jsonData) in
                
                let region = jsonData["name"].stringValue
                let degree = Int(jsonData["main"]["temp"].floatValue)
                let weather = jsonData["weather"][0]["main"].stringValue
                let description = jsonData["weather"][0]["description"].stringValue
                let unit = "ºC"
                
                let currentWeather = WeatherModel(region: region, degree: degree, weather: weather, description: description, unit: unit)
                
                self.regionLabel.text = currentWeather.region
                self.degreeLabel.text = "\(currentWeather.degree)"
                self.weatherLabel.text = currentWeather.weather
                self.descriptionLabel.text = currentWeather.description
                self.unitLabel.text = currentWeather.unit
                
                self.spinner.stopAnimating()
                self.spinner.alpha = 0
            }
        }
    }
    
}

