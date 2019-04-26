//
//  ViewController.swift
//  WeatherApp
//
//  Created by Saptami Biswas on 4/26/19.
//  Copyright © 2019 Saptami Biswas. All rights reserved.
//

import UIKit
import CoreLocation


class ViewController: UIViewController {

    @IBOutlet weak var topTimeLabel: UILabel!
    @IBOutlet weak var currentDate: UILabel!
    @IBOutlet weak var currentDay: UILabel!

    @IBOutlet weak var firstTMin: UILabel!
    @IBOutlet weak var firstTMax: UILabel!
    @IBOutlet weak var secondTMin: UILabel!
    @IBOutlet weak var secondTMax: UILabel!
    @IBOutlet weak var thirdTMin: UILabel!
    @IBOutlet weak var thirdTMax: UILabel!
    @IBOutlet weak var currentCityOutlet: UIButton!
    @IBOutlet weak var newCityTextField: UITextField!
    
    var forecastData = [WeatherJSON]()
    //var dailyForecastData = [CurrentWeatherJSON]()
    //var hourlyForecastData = [HourlyWeatherJSON]()
    let clock = Clock()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //initializing the temperature outlets as null
        firstTMin.text? = ""
        firstTMax.text? = ""
        secondTMin.text? = ""
        secondTMax.text? = ""
        thirdTMin.text? = ""
        thirdTMax.text? = ""
        
        // current date and time setup
        let time = DateFormatter()
        time.timeStyle = .short
        let date = DateFormatter()
        date.dateFormat = "MMMM, dd"
        let weekday = DateFormatter()
        weekday.dateFormat = "EEEE"
        
        // time label
        topTimeLabel.text? = time.string(from: clock.currentTime as Date)
        
        // date and month label
        currentDate.text? = date.string(from: Date())
        
        //weekday label
        currentDay.text? = weekday.string(from: Date())
        
        //update the vlock time periodically
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(ViewController.updateClock), userInfo: nil, repeats: true)
        
        //showCurrentWeatherForLocation(location: "Stillwater")
        updateWeatherForLocation(location: "Stillwater")
        
    }
    
    func updateWeatherForLocation(location: String)
    {
        CLGeocoder().geocodeAddressString(location) { (placemarks: [CLPlacemark]?, error: Error?) in
            if error == nil
            {
                if let location = placemarks?.first?.location
                {
                    print("Location ", location)
                    
                    WeatherJSON.forecast(withLocation: location.coordinate, completion: {(results:[WeatherJSON]?) in
                        
                        if let weatherData = results{
                            self.forecastData = weatherData
                            //print(self.forecastData)
                            
                            
                            DispatchQueue.main.async {
                                self.firstTMin.text? = "\(Int(self.forecastData[0].temperatureMin)) °F"
                                self.firstTMax.text? = "\(Int(self.forecastData[0].temperatureMax)) °F"
                                self.secondTMin.text? = "\(Int(self.forecastData[1].temperatureMin)) °F"
                                self.secondTMax.text? = "\(Int(self.forecastData[1].temperatureMax)) °F"
                                self.thirdTMin.text? = "\(Int(self.forecastData[2].temperatureMin)) °F"
                                self.thirdTMax.text? = "\(Int(self.forecastData[2].temperatureMax)) °F"
                            }
                            
                        }
                    })
                }
            }
        }
    }
    
    // updateclock function
    @objc func updateClock()
    {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        topTimeLabel?.text = formatter.string(from: clock.currentTime as Date)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }


}

