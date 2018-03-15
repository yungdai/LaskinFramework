//
//  JSONParser.swift
//  EMobileView
//
//  Created by Yung Dai on 2016-11-02.
//  Copyright © 2016 Yung Dai. All rights reserved.
//

import Foundation
import CoreLocation

public class JSONParser: NSObject {

    public func parseJSON(json data: Data) -> Payload? {
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments, .mutableContainers]) as? Payload

             return json
            
        } catch {
            
            print("JSON Error: \(error)")
            return nil
        }
    }
    
    public func getCurrentLocationWeather(json weatherData: Payload, city: String, province: String) -> String {

        var locationString: String = ""
        
        if let weather = weatherData["currently"] as? Payload {
            
                if let temperature = weather["temperature"] as? Double,
                let forcast = weather["summary"] as? String {
                let temp = self.convertFToC(temperature)
                let summary = forcast
                
                    let  tempStr = String(format: "%.1f", temp)
                locationString = "Today in \(city), \(province) \n\(tempStr)°C \(summary)"
            }
        }

        return locationString
    }
    
    public func getCurrentWeatherWithoutCityInformation(json weatherData: Payload) -> String {
   
        var locationString = ""
        
        if let weather = weatherData["currently"] as? Payload,
            let temperature = weather["temperature"] as? Double,
            let forcast = weather["summary"] as? String {
            
                let temp = convertFToC(temperature)
                let summary = forcast
                
                let  tempStr = String(format: "%.1f", temp)
                locationString = "Today at your location \n\(tempStr)°C \(summary)"
        }
        
        return locationString

    }

    public func convertFToC(_ temperatureInF: Double) -> Double {
        
        let temp = (temperatureInF - 32) / 1.8
        
        return temp
    }
}




