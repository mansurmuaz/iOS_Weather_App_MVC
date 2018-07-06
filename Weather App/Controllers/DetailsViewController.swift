//
//  DetailsViewController.swift
//  Weather App
//
//  Created by Mansur Muaz  Ekici on 5.07.2018.
//  Copyright © 2018 Adesso. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var backgroundImage: UIImageView!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var image:UIImage? = nil
    
    var location = Location()
    var weatherArray = [WeatherModel]()
    
    let networkService = NetworkService.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundImage.image = image
        
        getCurrentWeather()
        getFiveDaysWeather()
        
    }

    func getCurrentWeather() {
        networkService.getWeather(lat: location.latitude, lon: location.longitude) { (jsonData) in
            
            let currentWeather = WeatherModel(json: jsonData)
            
            self.nameLabel.text = currentWeather.name
            self.degreeLabel.text = "\(currentWeather.degree)"
            self.weatherLabel.text = currentWeather.weather
            self.descriptionLabel.text = currentWeather.description
            self.windLabel.text = "\(currentWeather.wind)"
            self.humidityLabel.text = "\(currentWeather.humidity)"
            self.unitLabel.text = currentWeather.unit
            
            UIView.transition(with: self.backgroundImage,
                              duration: 1,
                              options: .transitionCrossDissolve,
                              animations: {self.backgroundImage.image = currentWeather.image},
                              completion: nil)
        }
    }
    
    func getFiveDaysWeather(){
        networkService.getFiveDaysWeather(lat: location.latitude, lon: location.longitude) { (jsonData) in
            
            for weatherJSON in jsonData["list"].arrayValue{
                if weatherJSON["dt_txt"].stringValue.split(separator: " ")[1].starts(with: "12"){
                    
                    let weather = WeatherModel(json: weatherJSON)
                    
                    self.weatherArray.append(weather)
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func formatDate (dateString: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        dateFormatter.timeZone = TimeZone.current
        let date = dateFormatter.date(from: dateString)
        dateFormatter.dateFormat = "EEEE, MMM d"
        
        return dateFormatter.string(from: date!)
    }
}

extension DetailsViewController: UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let weather = weatherArray[indexPath.row]
        
        cell.textLabel?.text = formatDate(dateString: "\(weather.date.split(separator: " ").first!)")
        cell.detailTextLabel?.text = "\(weather.degree)"
        
        return cell
    }
}
