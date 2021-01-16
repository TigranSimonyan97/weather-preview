//
//  Storage.swift
//  WeatherPreview
//
//  Created by Tigran Simonyan on 1/14/21.
//

import Foundation

protocol IdentifiableEntity {
    var id: String { get set }
}

protocol Storage {
    associatedtype Entity: IdentifiableEntity
    
    func getEntity(with id: String) -> Entity?
    func getEntities(with ids: [String]) -> [Entity]
    func getEntities(predicate: NSPredicate?, sortedBy keyPath: String?, ascending: Bool?) -> [Entity]
    func getAll() -> [Entity]
    
    func insertEntity(_ entity: Entity) -> Bool
    func insertEntities(_ entities: [Entity]) -> Bool
    
    func updateEntity(_ newEntity: Entity) -> Bool
    
    func removeEntity(_ entity: Entity) -> Bool
    func removeEntity(with id: String) -> Bool
    func removeEntities(_ entities: [Entity]) -> Bool
    func removeEntities(with ids: [String]) -> Bool
    func removeAll() -> Bool
}
