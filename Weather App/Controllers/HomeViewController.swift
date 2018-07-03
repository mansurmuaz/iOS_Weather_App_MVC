//
//  HomeViewController.swift
//  Weather App
//
//  Created by Mansur Muaz  Ekici on 3.07.2018.
//  Copyright © 2018 Adesso. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class HomeViewController: UIViewController, CLLocationManagerDelegate {

    
    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var degreeSymbolLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    let weather = Weather()

    let locationManager:CLLocationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.regionLabel.text = ""
        self.degreeLabel.text = ""
        self.weatherLabel.text = ""
        self.descriptionLabel.text = ""
        self.degreeSymbolLabel.text = ""
        
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
            spinner.startAnimating()
        }
    }
    
    
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
            
            weather.getCurrentWeather(lat: Float(lat), lon: Float(lon)) { (jsonData) in
                
                self.regionLabel.text = jsonData["name"].string
                self.degreeLabel.text = "\(Int(jsonData["main"]["temp"].floatValue))"
                self.weatherLabel.text = jsonData["weather"][0]["main"].stringValue
                self.descriptionLabel.text = jsonData["weather"][0]["description"].stringValue
                self.degreeSymbolLabel.text = "ºC"
                
                self.spinner.stopAnimating()
                self.spinner.alpha = 0
            }
        }
    }

}

