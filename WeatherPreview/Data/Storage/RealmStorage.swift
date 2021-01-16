//
//  RealmStorage.swift
//  WeatherPreview
//
//  Created by Tigran Simonyan on 1/14/21.
//

import Foundation
import RealmSwift

protocol IdentifiableEntityObject : Object & IdentifiableEntity {
    
}

class RealmStorage<EntityType: IdentifiableEntityObject>: Storage {
        
    typealias Entity = EntityType
    private var realm = try! Realm()
    
    init() {

    }
    
    init(realm: Realm) {
        self.realm = realm
    }
    
    func getEntity(with id: String) -> Entity? {
        return realm.object(ofType: Entity.self, forPrimaryKey: id)
    }
    
    func getEntities(with ids: [String]) -> [Entity] {
        return ids.compactMap { getEntity(with: $0) }
    }
    
    func getEntities(predicate: NSPredicate? = nil, sortedBy keyPath: String? = nil, ascending: Bool? = nil) -> [Entity] {
        let aPredicate = predicate != nil ? predicate! : NSPredicate(value: true)
        let sortingKeyPath = keyPath != nil ? keyPath! : "id"
        let sortingByAscending = ascending != nil ? ascending! : true
        return realm.objects(Entity.self).filter(aPredicate).sorted(byKeyPath: sortingKeyPath, ascending: sortingByAscending).toArray(ofType: Entity.self)
    }
    
    func getAll() -> [Entity] {
        return realm.objects(Entity.self).toArray(ofType: Entity.self)
    }
    
    @discardableResult
    func insertEntity(_ entity: Entity) -> Bool {
        try! realm.write{
            realm.add(entity, update: .modified)
            return true
        }
    }
    
    @discardableResult
    func insertEntities(_ entities: [Entity]) -> Bool {
        var isAllEntitiesInserted = true
        entities.forEach { isAllEntitiesInserted = isAllEntitiesInserted && insertEntity($0) }
        if isAllEntitiesInserted {
            print("All Entities successfully Inserted")
        } else {
            print("There where problem during insertion. Some of entities can be not inserted!!!")
        }
        
        return isAllEntitiesInserted
    }
    
    @discardableResult
    func updateEntity(_ newEntity: Entity) -> Bool {
        try! realm.write {
            realm.add(newEntity, update: .modified)
            return true
        }
    }
    
    @discardableResult
    func removeEntity(_ entity: Entity) -> Bool {
        try! realm.write {
            realm.delete(entity)
            return true
        }
    }
    
    @discardableResult
    func removeEntity(with id: String) -> Bool {
        guard let entity = getEntity(with: id) else {
            print("There is no entity \(Entity.self) with id \(id)")
            return false
        }
        return removeEntity(entity)
    }
    
    @discardableResult
    func removeEntities(_ entities: [Entity]) -> Bool {
        var isAllEntitiesRemoved = true
        entities.forEach { isAllEntitiesRemoved = isAllEntitiesRemoved && removeEntity($0) }
        if isAllEntitiesRemoved {
            print("All Entities successfully Removed, \(Entity.self)")
        } else {
            print("There where problem during removing. Some of entities can be not removed!!!")
        }
        
        return isAllEntitiesRemoved
    }
    
    @discardableResult
    func removeEntities(with ids: [String]) -> Bool {
        let entites = ids.compactMap { getEntity(with: $0) }
        let isAllEntitiesRemoved = removeEntities(entites)
        return isAllEntitiesRemoved && ids.count == entites.count
    }
    
    @discardableResult
    func removeAll() -> Bool {
        let allEntites = getAll()
        return removeEntities(allEntites)
    }
}
