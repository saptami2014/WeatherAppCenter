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

    // current time, day and date labels
    @IBOutlet weak var topTimeLabel: UILabel!
    @IBOutlet weak var currentDate: UILabel!
    @IBOutlet weak var currentDay: UILabel!

   
    // current weather information information
    @IBOutlet weak var todayWeatherOutlet: UILabel!
    @IBOutlet weak var todayTempOutlet: UILabel!
    @IBOutlet weak var todayWeatherSummary: UILabel!
    
   
    // the button labels
    @IBOutlet weak var currentTempButtonOutlet: UIButton!
    @IBOutlet weak var currentCityLabelButtonLabel: UIButton!
    
   
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
    
    
    //icon image view
    @IBOutlet weak var iconImageView: UIImageView!
    
    var hourTemp : String = ""
    var imageIcon : String = ""
    var temp : String = ""
    var iconText : String = ""
    var summaryText : String = ""
    
    var forecastData = [WeatherJSON]()
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
        todayWeatherSummary.text? = ""
        todayTempOutlet.text? = ""
        todayWeatherOutlet.text? = ""
        currentTempButtonOutlet.setTitle("", for: .normal)

        
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
        
        showCurrentWeatherForLocation(location: "Stillwater")
        
        updateWeatherForLocation(location: "Stillwater")
        
    
        // to set next three days
        setAllDays()
    }
    
    func showCurrentWeatherForLocation(location: String)
    {
        CLGeocoder().geocodeAddressString(location) { (placemarks: [CLPlacemark]?, error: Error?) in
            if error == nil
            {
                if let location = placemarks?.first?.location
                {
                    // current weather forecast
                    self.currentForecast(withLocation: location.coordinate)
                    
                    // hourly weather forecast
                    self.hourlyForecast(withLocation: location.coordinate)
                }
            }
        }
    }
    
    
    // hourly forecast
    func hourlyForecast (withLocation location: CLLocationCoordinate2D)
    {
        let url = "https://api.darksky.net/forecast/9611d5e7c2754ea4d423e30f1d258583/37.8267,-122.4233" /*+ "\(location.latitude),\(location.longitude)"*/
        let request = URLRequest (url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard error == nil else { return }
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String : Any],
                    let hourly = json["hourly"] as? [String : Any],
                    let data = hourly["data"] as? [[String : Any]],
                    data.count > 14,
                    let hTemp = data[14]["temperature"] as? Double {
                    self!.hourTemp = String(Int(hTemp))
                    print(hTemp)
                    let iconDum = data[14]["icon"] as? String
    
                    self!.imageIcon = iconDum!
                    print("imageIcon = ", self!.imageIcon)
                
                }
            }
            catch let jsonError
            {
                print(jsonError.localizedDescription)
            }
            
            DispatchQueue.main.async
            {
                self!.currentTempButtonOutlet.setTitle(self!.hourTemp + " °F", for: .normal)
                self!.iconImageView.image = UIImage(named: self!.imageIcon)
            }
        }
        task.resume()
    }
    
    
    // current forecast
    func currentForecast(withLocation location : CLLocationCoordinate2D)
    {

        let url = "https://api.darksky.net/forecast/9611d5e7c2754ea4d423e30f1d258583/" + "\(location.latitude),\(location.longitude)"
        let request = URLRequest (url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: request)
        {
            (data: Data?, request: URLResponse?, error: Error?) in
            if error == nil
            {
                do
                {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : Any]

                    if let currently = json["currently"] as? [String : Any] {
                        
                        if let chance2 = currently["temperature"] as? Double{
                            self.temp = String(Int(chance2))
                        }
                        
                        if let iconDum = currently["icon"] as? String
                        {
                           self.iconText = String(iconDum)
                        }
                        
                        if let summaryDum = currently["summary"] as? String
                        {
                            self.summaryText = String(summaryDum)
                        }
                    
                        // update currentWeather information
                        DispatchQueue.main.async
                        {
                            self.todayWeatherOutlet.text? = self.iconText
                            self.todayTempOutlet.text? = self.temp + " °F"
                            self.todayWeatherSummary.text? = self.summaryText
                        }
                        if let _ = json["error"]{
                        }

                    }
                    
                }
                catch{
                    print(error.localizedDescription)
                }
            }
       }
        task.resume()
    }
    
    func updateWeatherForLocation(location: String)
    {
        CLGeocoder().geocodeAddressString(location) { (placemarks: [CLPlacemark]?, error: Error?) in
            if error == nil
            {
                if let location = placemarks?.first?.location
                {
                    
                    WeatherJSON.forecast(withLocation: location.coordinate, completion: {(results:[WeatherJSON]?) in
                        
                        if let weatherData = results{
                            self.forecastData = weatherData
                            
                            
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

        let firstNextDay = DateFormatter()
        firstNextDay.dateFormat = "MMMM, dd"
        let firstWeekday = DateFormatter()
        firstWeekday.dateFormat = "EEEE"
        
        firstDate.text? = firstNextDay.string(from: oneDate)
        firstDay.text? = firstWeekday.string(from: oneDate)
        
        
        // 2nd next day
        let twoDate = Date.init(timeIntervalSinceNow: 172800)

        let secondNextDay = DateFormatter()
        secondNextDay.dateFormat = "MMMM, dd"
        let secondWeekday = DateFormatter()
        secondWeekday.dateFormat = "EEEE"
        
        secondDate.text? = secondNextDay.string(from: twoDate)
        secondDay.text? = secondWeekday.string(from: twoDate)
        
        
        // 3rd next day
        let threeDate = Date.init(timeIntervalSinceNow: 259200)

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
    
    
    // hit the current temperature to convert the temperature scale
    @IBAction func toggleTemperatue(_ sender: UIButton)
    {
        let stringS = currentTempButtonOutlet.titleLabel?.text
        if stringS!.characters.contains("F")
        {
            var delimiter = " "
            var newStringS = stringS?.components(separatedBy: " ")
            
            // set for current temperature label
            let currTempC = tempConvertFTC(tempFahrenheit: Int(newStringS![0])!)
            
            newStringS![0] = String(currTempC) + " °C"
            currentTempButtonOutlet.setTitle(newStringS![0], for: .normal)
            
            // set for today temperature label
            let tString = todayTempOutlet.text?.components(separatedBy: " ")
            todayTempOutlet.text? = String(tempConvertFTC(tempFahrenheit: Int(tString![0])!)) + " °C"
            
            // set for 1st next day minimum temperature label
            let firstTString = firstTMin.text?.components(separatedBy: " ")
            firstTMin.text? = String(tempConvertFTC(tempFahrenheit: Int(firstTString![0])!)) + " °C"
            
            // set for 1st next day maximum temperature label
            let firstTMaxString = firstTMax.text?.components(separatedBy: " ")
            firstTMax.text? = String(tempConvertFTC(tempFahrenheit: Int(firstTMaxString![0])!)) + " °C"
            
            
            //set for 2nd next day minimum temperature label
            let secondTString = secondTMin.text?.components(separatedBy: " ")
            secondTMin.text? = String(tempConvertFTC(tempFahrenheit: Int(secondTString![0])!)) + " °C"

            // set for 2nd next day maximum temperature label
            let secondTMaxString = secondTMax.text?.components(separatedBy: " ")
            secondTMax.text? = String(tempConvertFTC(tempFahrenheit: Int(secondTMaxString![0])!)) + " °C"

            // set for today temperature label
            let thirdTString = thirdTMin.text?.components(separatedBy: " ")
            thirdTMin.text? = String(tempConvertFTC(tempFahrenheit: Int(thirdTString![0])!)) + " °C"

            // set for today temperature label
            let thirdTMaxString = thirdTMax.text?.components(separatedBy: " ")
            thirdTMax.text? = String(tempConvertFTC(tempFahrenheit: Int(thirdTMaxString![0])!)) + " °C"
        }
        
        else
        {
            var delimiter = " "
            var newStringS = stringS?.components(separatedBy: " ")
            
            // set for current temperature label
            let currTempF = tempConvertCTF(tempCelsius: Int(newStringS![0])!)
            
            newStringS![0] = String(currTempF) + " °F"
            currentTempButtonOutlet.setTitle(newStringS![0], for: .normal)
            
            // set for today temperature label
            let tString = todayTempOutlet.text?.components(separatedBy: " ")
            todayTempOutlet.text? = String(tempConvertCTF(tempCelsius: Int(tString![0])!)) + " °F"
            
            // set for 1st next day minimum temperature label
            let firstTString = firstTMin.text?.components(separatedBy: " ")
            firstTMin.text? = String(tempConvertCTF(tempCelsius: Int(firstTString![0])!)) + " °F"
            
            // set for 1st next day maximum temperature label
            let firstTMaxString = firstTMax.text?.components(separatedBy: " ")
            firstTMax.text? = String(tempConvertCTF(tempCelsius:  Int(firstTMaxString![0])!)) + " °F"
            
            
            //set for 2nd next day minimum temperature label
            let secondTString = secondTMin.text?.components(separatedBy: " ")
            secondTMin.text? = String(tempConvertCTF(tempCelsius: Int(secondTString![0])!)) + " °F"
            
            // set for 2nd next day maximum temperature label
            let secondTMaxString = secondTMax.text?.components(separatedBy: " ")
            secondTMax.text? = String(tempConvertCTF(tempCelsius: Int(secondTMaxString![0])!)) + " °F"
            
            // set for today temperature label
            let thirdTString = thirdTMin.text?.components(separatedBy: " ")
            thirdTMin.text? = String(tempConvertCTF(tempCelsius: Int(thirdTString![0])!)) + " °F"
            
            // set for today temperature label
            let thirdTMaxString = thirdTMax.text?.components(separatedBy: " ")
            thirdTMax.text? = String(tempConvertCTF(tempCelsius: Int(thirdTMaxString![0])!)) + " °F"
        }
    }
    
    
    // hit the current city button to change the location
    
    @IBAction func currentCityChangeActionButton(_ sender: UIButton) {
    }
    
    
    
    // convert temperature from fahrenheit to celsius
    func tempConvertFTC(tempFahrenheit: Int) -> Int
    {
        let tempCelsius = (tempFahrenheit - 32) * 5 / 9
        return tempCelsius
    }
    
    
    // convert temperature from celsius to fahrenheit
    func tempConvertCTF(tempCelsius: Int) -> Int
    {
        let tempFahren = tempCelsius * 9 / 5 + 32
        return tempFahren
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }


}

