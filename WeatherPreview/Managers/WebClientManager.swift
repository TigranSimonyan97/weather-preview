//
//  WebClientManager.swift
//  WeatherPreview
//
//  Created by Tigran Simonyan on 1/15/21.
//

import Foundation
import CoreLocation

enum RequestError : Error {
    case invalidURL(String)
    case requestFail(String)
    case emptyData
    case other(Error)
    
    static func map(_ error: Error) -> RequestError {
      return (error as? RequestError) ?? .other(error)
    }
}


class WebClientManager {
    
    static let iconsBasePath = "http://openweathermap.org/img/w/"
    
    private let API_ID = "051aa3ecbba1eba9ff3f767612bd38fe"
    private let BASE_PATH = "https://api.openweathermap.org/data/2.5/onecall?"
    private let EXCLUDE = "&exclude=minutely,hourly"
    private let UNITS = "&units=metric"
    func loadWeather(for location: CLLocation, completion: @escaping (WeatherResponse?, RequestError?) -> Void) {
        let coordinate = location.coordinate
        let path = "\(BASE_PATH)lat=\(coordinate.latitude)&lon=\(coordinate.longitude)\(EXCLUDE)\(UNITS)&appid=\(API_ID)"
        guard let url = URL(string: path) else {
            print("invalid URL. Path is \(path)")
            completion(nil, RequestError.invalidURL(path))
            return
        }
        
        let session = URLSession.shared
        
        session.dataTask(with: url) { (data, _, error) in
            if let err = error {
                print("Occured error during data fetching. Error is \(err.localizedDescription)")
                completion(nil, RequestError.requestFail(err.localizedDescription))
                return
            }
            
            let decoder = JSONDecoder()
            
            guard let data = data else {
                print("There is no new date during fetching")
                completion(nil, RequestError.emptyData)
                return
            }
            
            do {
                let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
                completion(weatherResponse, nil)
            } catch let error {
                print("There is no new date during fetching. Error is \(error.localizedDescription)")
                completion(nil, RequestError.other(error))
                return
            }
        }.resume()
    }
    
}
