//
//  Temperature.swift
//  WeatherPreview
//
//  Created by Tigran Simonyan on 1/15/21.
//

import Foundation
import RealmSwift

struct Temperature : Decodable {
    let day: Float
    let min: Float
    let max: Float
    
    init?(temperatureDataModel: TemperatureDataModel) {
        guard let day = temperatureDataModel.day.value ,
              let min = temperatureDataModel.min.value ,
              let max = temperatureDataModel.max.value else { return nil }
        self.day = day
        self.min = min
        self.max = max
    }
    
    init(day: Float) {
        self.day = day
        min = day
        max = day
    }
}

class TemperatureDataModel : Object & IdentifiableEntity {
    @objc dynamic var id: String = UUID().uuidString
    var day = RealmOptional<Float>()
    var min = RealmOptional<Float>()
    var max = RealmOptional<Float>()

    convenience init(temperature: Temperature) {
        self.init()
        self.day.value = temperature.day
        self.min.value = temperature.min
        self.max.value = temperature.max
    }
    
    override required init() {
        super.init()
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }

}

extension TemperatureDataModel : IdentifiableEntityObject {
    
}
