//
//  CurrentJSON.swift
//  WeatherApp
//
//  Created by Saptami Biswas on 4/26/19.
//  Copyright © 2019 Saptami Biswas. All rights reserved.
//

import Foundation
import CoreLocation

struct CurrentJSON
{
    let summary : String
    let temperature : Double
    let icon : String
    
    enum SerializationError : Error
    {
        case missing (String)
        case invalid (String, Any)
    }
    
    init (json : [String : Any]) throws
    {
        
        guard let summary = json["summary"] as? String
            else
        {
            throw SerializationError.missing("Summary is missing")
        }
        
        guard let temperature = json["temperature"] as? Double
            else
        {
            throw SerializationError.missing("Temperature is missing")
        }
        
        guard let icon = json["icon"] as? String
            else
        {
            throw SerializationError.missing("Icon is missing")
        }
        
        self.summary = summary
        self.temperature = temperature
        self.icon = icon
    }
    
    static let basePath = "https://api.darksky.net/forecast/9611d5e7c2754ea4d423e30f1d258583/"
    
    static func forecast(withLocation location : CLLocationCoordinate2D)
    {
        let url = basePath + "\(location.latitude),\(location.longitude)"
        let request = URLRequest (url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request)
        {
            (data: Data?, request: URLResponse?, error: Error?) in
        //task.resume()
        }
    }
}
