//
//  WeatherInfo.swift
//  WeatherPreview
//
//  Created by Tigran Simonyan on 1/15/21.
//

import Foundation

struct WeatherInfo {
    let date: Int
    let tempreture: Temperature
    let sunriseDate: Int
    let sunsetDate: Int
    let cloudsPercent: Int
    let windSpeed: Float
    let humidity: Int
    let pressure: Int
    let mainInfo: [WeatherMainInfo]
    
    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case tempreture = "temp"
        case sunriseDate = "sunrise"
        case sunsetDate = "sunset"
        case cloudsPercent = "clouds"
        case windSpeed = "wind_speed"
        case humidity
        case pressure
        case mainInfo = "weather"
    }
}
