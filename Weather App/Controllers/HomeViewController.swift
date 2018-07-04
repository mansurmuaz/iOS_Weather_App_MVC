//
//  HomeViewController.swift
//  Weather App
//
//  Created by Mansur Muaz  Ekici on 3.07.2018.
//  Copyright © 2018 Adesso. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData

class HomeViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var regionLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var appDelegate: AppDelegate!
    var context: NSManagedObjectContext!
    
    let networkService = NetworkService.sharedInstance

    let locationManager:CLLocationManager = CLLocationManager()
    
    var locations: [Location] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.regionLabel.text = ""
        self.degreeLabel.text = ""
        self.weatherLabel.text = ""
        self.descriptionLabel.text = ""
        self.unitLabel.text = ""

        //deleteAllRecords()
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
            spinner.startAnimating()
        }
        
        getLocations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getLocations()
    }
    
    func getLocations() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        
        request.returnsObjectsAsFaults = false
        
        do{
            if let locationsData = try context.fetch(request) as? [Location]{
                locations = locationsData
                tableView.reloadData()
            }
        }catch{
            print("Error while fetching data")
        }
    }
    
    func deleteLocation(index: Int) {
        let deletedLocation = locations[index]
        context.delete(deletedLocation)
        do {
            try context.save()
        } catch {
            print("Error while deleting location")
        }
        locations.remove(at: index)
    }
    
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

    func deleteAllRecords() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
}

extension HomeViewController: UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if !locations.isEmpty {
            
            cell.textLabel?.text = locations[indexPath.row].name
            
            networkService.getWeather(lat: locations[indexPath.row].latitude, lon: locations[indexPath.row].longitude) { (jsonData) in
                
                let weather = WeatherModel(json: jsonData)
                
                cell.detailTextLabel?.text = "\(weather.degree)\(weather.unit)"
            }
        }
        return cell
    }
    

    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            
            deleteLocation(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
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


    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            let lon = location.coordinate.longitude
            let lat = location.coordinate.latitude

            networkService.getWeather(lat: lat, lon: lon) { (jsonData) in
    
                let currentWeather = WeatherModel(json: jsonData)
                
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

