//
//  WeatherInfo.swift
//  WeatherPreview
//
//  Created by Tigran Simonyan on 1/15/21.
//

import Foundation
import RealmSwift

struct WeatherInfo : Decodable {
    let date: Int
    let temperature: Temperature
    let sunriseDate: Int
    let sunsetDate: Int
    let cloudsPercent: Int
    let windSpeed: Float
    let humidity: Int
    let pressure: Int
    let mainInfo: [WeatherDescription]
    
    init?(weatherInfoDataModel: WeatherInfoDataModel) {
        guard let date = weatherInfoDataModel.date.value,
              let temperatureDataModel = weatherInfoDataModel.temperature,
              let temperature = Temperature(temperatureDataModel: temperatureDataModel),
              let sunriseDate = weatherInfoDataModel.sunriseDate.value,
              let sunsetDate = weatherInfoDataModel.sunsetDate.value,
              let cloudsPercent = weatherInfoDataModel.cloudsPercent.value,
              let windSpeed = weatherInfoDataModel.windSpeed.value,
              let humidity = weatherInfoDataModel.humidity.value,
              let pressure = weatherInfoDataModel.pressure.value
              else { return nil }
        
        let mainInfo = weatherInfoDataModel.mainInfo.compactMap({ (description) -> WeatherDescription? in
            WeatherDescription(weatherDescriptionDataModel: description)
        })
        
        self.date = date
        self.temperature = temperature
        self.sunriseDate = sunriseDate
        self.sunsetDate = sunsetDate
        self.cloudsPercent = cloudsPercent
        self.windSpeed = windSpeed
        self.humidity = humidity
        self.pressure = pressure
        self.mainInfo = Array(mainInfo)
    }
    
    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case temperature = "temp"
        case sunriseDate = "sunrise"
        case sunsetDate = "sunset"
        case cloudsPercent = "clouds"
        case windSpeed = "wind_speed"
        case humidity
        case pressure
        case mainInfo = "weather"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        date = try values.decode(Int.self, forKey: .date)
        if let temp = try? values.decode(Temperature.self, forKey: .temperature) {
            self.temperature = temp
        } else {
            let fahrenheit = try values.decode(Float.self, forKey: .temperature)
            let temp = Temperature(day: fahrenheit)
            self.temperature = temp
        }
        sunriseDate = try values.decode(Int.self, forKey: .sunriseDate)
        sunsetDate = try values.decode(Int.self, forKey: .sunsetDate)
        cloudsPercent = try values.decode(Int.self, forKey: .cloudsPercent)
        windSpeed = try values.decode(Float.self, forKey: .windSpeed)
        humidity = try values.decode(Int.self, forKey: .humidity)
        pressure = try values.decode(Int.self, forKey: .pressure)
        mainInfo = try values.decode([WeatherDescription].self, forKey: .mainInfo)
    }
}

class WeatherInfoDataModel : Object & IdentifiableEntity {
    @objc dynamic var id: String = UUID().uuidString
    var date = RealmOptional<Int>()
    @objc dynamic var temperature: TemperatureDataModel?
    var sunriseDate = RealmOptional<Int>()
    var sunsetDate = RealmOptional<Int>()
    var cloudsPercent = RealmOptional<Int>()
    var windSpeed = RealmOptional<Float>()
    var humidity = RealmOptional<Int>()
    var pressure = RealmOptional<Int>()
    var mainInfo = List<WeatherDescriptionDataModel>()

    @objc dynamic var iconName: String?

    convenience init(weatherInfo: WeatherInfo) {
        self.init()
        self.date.value = weatherInfo.date
        self.temperature = TemperatureDataModel(temperature: weatherInfo.temperature)
        self.sunriseDate.value = weatherInfo.sunriseDate
        self.sunsetDate.value = weatherInfo.sunsetDate
        self.cloudsPercent.value = weatherInfo.cloudsPercent
        self.windSpeed.value = weatherInfo.windSpeed
        self.humidity.value = weatherInfo.humidity
        self.pressure.value = weatherInfo.pressure
        self.windSpeed.value = weatherInfo.windSpeed
        let mainInfoDataModels = weatherInfo.mainInfo.map { WeatherDescriptionDataModel(weatherDescription: $0)
        }
        self.mainInfo = mainInfoDataModels.toRealmList()
    }
    
    override required init() {
        super.init()
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }

}

extension WeatherInfoDataModel : IdentifiableEntityObject {
    
}

