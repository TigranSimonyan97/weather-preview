//
//  TemperatureMock.swift
//  WeatherPreview
//
//  Created by Tigran Simonyan on 1/16/21.
//

import Foundation
import RealmSwift

class TemperatureMock : Object & IdentifiableEntity {
    @objc dynamic var id: String = UUID().uuidString
    var day = RealmOptional<Float>()
    
    override required init() {
        super.init()
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }

}

extension TemperatureMock : IdentifiableEntityObject {
    
}
