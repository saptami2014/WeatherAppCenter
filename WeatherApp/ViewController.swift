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

    // next 3 days
    @IBOutlet weak var firstDate: UILabel!
    @IBOutlet weak var firstDay: UILabel!
    @IBOutlet weak var secondDate: UILabel!
    @IBOutlet weak var secondDay: UILabel!
    @IBOutlet weak var thirdDate: UILabel!
    @IBOutlet weak var thirdDay: UILabel!
    
    
    // temperature min and max outlets
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
        print("date = ", date)
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
        
        
        // to set next three days
        setAllDays()
        
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
    
    func setAllDays()
    {
        let date = Date()

        // 1st next day
        let oneDate = Date.init(timeIntervalSinceNow: 86400)
        print("cd = ", oneDate)
        let firstNextDay = DateFormatter()
        firstNextDay.dateFormat = "MMMM, dd"
        let firstWeekday = DateFormatter()
        firstWeekday.dateFormat = "EEEE"
        
        firstDate.text? = firstNextDay.string(from: oneDate)
        firstDay.text? = firstWeekday.string(from: oneDate)
        
        
        // 2nd next day
        let twoDate = Date.init(timeIntervalSinceNow: 172800)
        print("cd = ", twoDate)
        let secondNextDay = DateFormatter()
        secondNextDay.dateFormat = "MMMM, dd"
        let secondWeekday = DateFormatter()
        secondWeekday.dateFormat = "EEEE"
        
        secondDate.text? = secondNextDay.string(from: twoDate)
        secondDay.text? = secondWeekday.string(from: twoDate)
        
        
        // 3rd next day
        let threeDate = Date.init(timeIntervalSinceNow: 259200)
        print("cd = ", threeDate)
        let thirdNextDay = DateFormatter()
        thirdNextDay.dateFormat = "MMMM, dd"
        let thirdWeekday = DateFormatter()
        thirdWeekday.dateFormat = "EEEE"
        
        thirdDate.text? = secondNextDay.string(from: threeDate)
        thirdDay.text? = thirdWeekday.string(from: threeDate)
        
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

