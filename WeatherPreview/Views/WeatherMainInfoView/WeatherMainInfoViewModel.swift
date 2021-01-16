//
//  WeatherMainInfoViewModel.swift
//  WeatherPreview
//
//  Created by Tigran Simonyan on 1/14/21.
//

import Foundation
import RxSwift
import RxCocoa

class WeatherMainInfoViewModel {
        
    var weatherResponse = BehaviorRelay<WeatherResponse?>(value: nil)
    
    var city = BehaviorRelay<String?>(value: nil)
    var weatherInfo = BehaviorRelay<String?>(value: nil)
    var iconPath = BehaviorRelay<String?>(value: nil)
    
    init() {
    }
    
    init(weatherResponse: WeatherResponse) {
        self.weatherResponse = BehaviorRelay(value: weatherResponse)
    }
    
    func prepareCity() -> String? {
        guard let response = weatherResponse.value else { return nil }
        let timezoneComponents = response.timezone.components(separatedBy: "/")
        guard !timezoneComponents.isEmpty else { return nil }
        return timezoneComponents.last
    }
    
    func prepareWeatherInfo() -> String? {
        guard let weatherResponse = weatherResponse.value else {
            return nil
        }
        
        var weatherInfo = ""
        if let mainInfo = weatherResponse.currentWeather.mainInfo.first {
            weatherInfo = "\(mainInfo.mainInfo) - \(mainInfo.desc)\n"
        }

        if let temperature = getTemperatureInCelsius() {
            weatherInfo = weatherInfo + temperature
        }
        
        return weatherInfo
    }
    
    private func getTemperatureInCelsius() -> String? {
        guard let temp = weatherResponse.value?.currentWeather.temperature.day else { return nil }
        let celsius = Int(temp)
        
        return "\(celsius)°"
    }
    
    func prepareWeatherIconPath() -> String? {
        guard let response = weatherResponse.value  else { return nil }
        return response.currentWeather.mainInfo.first?.iconPath
    }
    
}
