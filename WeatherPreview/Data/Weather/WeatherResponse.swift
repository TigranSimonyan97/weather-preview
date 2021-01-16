//
//  WeatherResponse.swift
//  WeatherPreview
//
//  Created by Tigran Simonyan on 1/15/21.
//

import Foundation
import RealmSwift

struct WeatherResponse : Decodable {
    let timezone: String
    let currentWeather: WeatherInfo
    let dailyWeather: [WeatherInfo]
    
    init?(weatherResponseDataModel: WeatherResponseDataModel) {
        guard let timezone = weatherResponseDataModel.timezone,
              let currentWeatherDataModel = weatherResponseDataModel.currentWeather,
              let currentWeather = WeatherInfo(weatherInfoDataModel: currentWeatherDataModel)
        else { return nil }
        
        let dailyWeather = weatherResponseDataModel.dailyWeather.compactMap({ (dailyWeatherDataModel) -> WeatherInfo? in
            WeatherInfo(weatherInfoDataModel: dailyWeatherDataModel)
        })

        self.timezone = timezone
        self.currentWeather = currentWeather
        self.dailyWeather = Array(dailyWeather)
        
    }
    
    enum CodingKeys: String, CodingKey {
        case timezone
        case currentWeather = "current"
        case dailyWeather = "daily"
    }
}

class WeatherResponseDataModel : Object & IdentifiableEntity {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var timezone: String?
    var currentWeather: WeatherInfoDataModel?
    var dailyWeather = List<WeatherInfoDataModel>()
    
    convenience init(weatherResponse: WeatherResponse) {
        self.init()
        self.timezone = weatherResponse.timezone
        self.currentWeather = WeatherInfoDataModel(weatherInfo: weatherResponse.currentWeather)
        let dailyWeatherDataModels = weatherResponse.dailyWeather.map { WeatherInfoDataModel(weatherInfo: $0)
        }
        self.dailyWeather = dailyWeatherDataModels.toRealmList()
    }
    
    override required init() {
        super.init()
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }

}

extension WeatherResponseDataModel : IdentifiableEntityObject {
    
}

