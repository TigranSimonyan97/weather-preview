//
//  WeatherMainInfo.swift
//  WeatherPreview
//
//  Created by Tigran Simonyan on 1/15/21.
//

import Foundation
import RealmSwift

struct WeatherDescription : Decodable {
    let id: Int
    let mainInfo: String
    let desc: String
    let iconName: String
    
    var iconPath: String {
        "\(WebClientManager.iconsBasePath)\(iconName).png"
    }
    
    init?(weatherDescriptionDataModel: WeatherDescriptionDataModel) {
        guard let id = Int(weatherDescriptionDataModel.id),
              let mainInfo = weatherDescriptionDataModel.mainInfo,
              let desc = weatherDescriptionDataModel.desc,
              let iconName = weatherDescriptionDataModel.iconName else { return nil }
        
        
        self.id = id
        self.mainInfo = mainInfo
        self.desc = desc
        self.iconName = iconName
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case mainInfo = "main"
        case desc = "description"
        case iconName = "icon"
    }
}

class WeatherDescriptionDataModel : Object & IdentifiableEntity {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var mainInfo: String?
    @objc dynamic var desc: String?
    @objc dynamic var iconName: String?

    convenience init(weatherDescription: WeatherDescription) {
        self.init()
        self.id = "\(weatherDescription.id)"
        self.mainInfo = mainInfo
        self.desc = desc
        self.iconName = iconName
    }
    
    override required init() {
        super.init()
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }

}

extension WeatherDescriptionDataModel : IdentifiableEntityObject {
    
}

