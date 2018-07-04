//
//  AddBookmarkViewController.swift
//  Weather App
//
//  Created by Mansur Muaz  Ekici on 3.07.2018.
//  Copyright © 2018 Adesso. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class AddBookmarkViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var appDelegate: AppDelegate!
    var context: NSManagedObjectContext!

    let locationManager:CLLocationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotation(press:)))
        
        mapView.addGestureRecognizer(longPressGestureRecognizer)
        
    }

    
    @objc func addAnnotation(press: UILongPressGestureRecognizer){
        
        if press.state == .began {
            
            mapView.removeAnnotations(mapView.annotations)
            
            let pressedLocation = press.location(in: mapView)
            let coordinates = mapView.convert(pressedLocation, toCoordinateFrom: mapView)
            
            let location = CLLocation.init( latitude: coordinates.latitude, longitude: coordinates.longitude)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            
            CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
                if error != nil {
                    print(error.debugDescription)
                }else{
                    if let place = placemark?[0]{
                        if let locality = place.locality{
                            annotation.title = locality
                        }
                    }
                }
            }
            mapView.addAnnotation(annotation)
        
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        if mapView.annotations.count > 1 {
           
            for annotation in mapView.annotations{
                if annotation.title != "My Location"{
                    let latitude = annotation.coordinate.latitude
                    let longitude = annotation.coordinate.longitude

                    let newLocation = NSEntityDescription.insertNewObject(forEntityName: "Location", into: context)
                    
                    newLocation.setValue(latitude, forKey: "latitude")
                    newLocation.setValue(longitude, forKey: "longitude")
                    
                    if let locality = annotation.title{
                        newLocation.setValue(locality, forKey: "name")
                    }else{
                        newLocation.setValue("", forKey: "name")
                    }
                    do {
                        try context.save()
                    }catch{
                        print("Error while saving")
                    }
                    navigationController?.popViewController(animated: true)
                }
            }
        }else{
            print("add annotation alert")
        }
    }
}


extension AddBookmarkViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            let lon = location.coordinate.longitude
            let lat = location.coordinate.latitude

            let location = CLLocationCoordinate2DMake(lat, lon)
            let span = MKCoordinateSpanMake(0.5, 0.5)
            let region = MKCoordinateRegionMake(location, span)
            
            self.mapView.setRegion(region, animated: true)
            self.mapView.showsUserLocation = true
        }
    }
}

