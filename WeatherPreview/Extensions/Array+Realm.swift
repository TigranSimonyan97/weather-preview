//
//  Array+Realm.swift
//  WeatherPreview
//
//  Created by Tigran Simonyan on 1/15/21.
//

import Foundation
import RealmSwift

extension Array where Element: RealmCollectionValue {
    func toRealmList() -> List<Element> {
        let list = List<Element>()
        
        for element in self {
            list.append(element)
        }
        
        return list
    }
}

extension List {
    func toArray() -> [Element] {
        var array = [Element]()
        
        for element in self {
            array.append(element)
        }
        
        return array
    }
}

