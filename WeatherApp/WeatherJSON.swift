//
//  WeatherJSON.swift
//  WeatherApp
//
//  Created by Saptami Biswas on 4/26/19.
//  Copyright © 2019 Saptami Biswas. All rights reserved.
//

import Foundation
import CoreLocation

struct WeatherJSON
{
    let temperatureMin : Double
    let temperatureMax : Double
    
    enum SerializationError : Error
    {
        case missing (String)
        case invalid (String, Any)
    }
    
    init (json : [String : Any]) throws
    {
        
        guard let temperatureMin = json["temperatureMin"] as? Double
            else
        {
            throw SerializationError.missing("temperature is missing")
        }
        
        guard let temperatureMax = json["temperatureMax"] as? Double
            else
        {
            throw SerializationError.missing("temperature is missing")
        }
        
        self.temperatureMin = temperatureMin
        self.temperatureMax = temperatureMax
        
    }
    
    static let basePath = "https://api.darksky.net/forecast/9611d5e7c2754ea4d423e30f1d258583/"
    
    static func forecast(withLocation location : CLLocationCoordinate2D, completion: @escaping ([WeatherJSON]) -> ())
    {
        let url = basePath + "\(location.latitude),\(location.longitude)"
        let request = URLRequest (url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request)
        {
            (data: Data?, request: URLResponse?, error: Error?) in
            
            var forecastArray: [WeatherJSON] = []
            if let data = data
            {
                do
                {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    {
                        if let dailyForecasts = json["daily"] as? [String: Any]
                        {
                            if let dailyData = dailyForecasts["data"] as? [[String: Any]]
                            {
                                for dataPoint in dailyData
                                {
                                    if let weatherObject = try? WeatherJSON(json: dataPoint)
                                    {
                                        forecastArray.append(weatherObject)
                                    }
                                    
                                }
                            }
                        }
                    }
                }
                catch
                {
                    print(error.localizedDescription)
                }
                
                completion(forecastArray)
            }
        }
        
        task.resume()
    }
}

