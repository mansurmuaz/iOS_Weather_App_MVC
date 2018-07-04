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
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var bookmarksView: UIView!
    
    var appDelegate: AppDelegate!
    var context: NSManagedObjectContext!
    
    let networkService = NetworkService.sharedInstance

    let locationManager:CLLocationManager = CLLocationManager()
    
    var locations: [Location] = []
    var displayingLocations: [Location] = []
    
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
        displayingLocations = locations
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getLocations()
        displayingLocations = locations
        tableView.reloadData()
    }
    
    func getLocations() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Location")
        
        request.returnsObjectsAsFaults = false
        
        do{
            if let locationsData = try context.fetch(request) as? [Location]{
                locations = locationsData
            }
        }catch{
            print("Error while fetching data")
        }
    }
    
    func deleteLocation(index: Int) {

        let deletedLocation = displayingLocations[index]
        context.delete(deletedLocation)
        do {
            try context.save()
        } catch {
            print("Error while deleting location")
        }
        getLocations()
        displayingLocations.remove(at: index)
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
        return displayingLocations.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if !displayingLocations.isEmpty {
            
            cell.textLabel?.text = displayingLocations[indexPath.row].name
            
            networkService.getWeather(lat: displayingLocations[indexPath.row].latitude, lon: displayingLocations[indexPath.row].longitude) { (jsonData) in
                
                let weather = WeatherModel(json: jsonData)
                cell.detailTextLabel?.text = "\(weather.degree)\(weather.unit)"
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
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

extension HomeViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            displayingLocations = locations
            tableView.reloadData()
            return
        }
        displayingLocations = locations.filter({ (location) -> Bool in
             location.name!.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
}
