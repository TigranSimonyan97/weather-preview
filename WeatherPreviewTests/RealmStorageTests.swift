//
//  RealmStorageTests.swift
//  WeatherPreviewTests
//
//  Created by Tigran Simonyan on 1/16/21.
//

import XCTest

@testable import WeatherPreview
@testable import RealmSwift


class RealmStorageTests: XCTestCase {

    private var storage: RealmStorage<TemperatureMock>!
    private var entities = [TemperatureMock]()
    
    override func setUp() {
        storage = RealmStorage<TemperatureMock>()
        storage.removeEntities(entities)
        
        let temp1 = TemperatureMock()
        let temp2 = TemperatureMock()
        let temp3 = TemperatureMock()
        
        entities = [temp1, temp2, temp3]
    }

    override func tearDown() {
        
        entities = []
        storage = nil
    }
    
    func testInsertEntity() throws {
        
        let entity = TemperatureMock()
        let day: Float = -11
        entity.day.value = day
        
        let countBeforeInsertion = storage.getAll().count
        
        storage.insertEntity(entity)
        let countAfterInsertion = storage.getAll().count
        
        let diff = countAfterInsertion - countBeforeInsertion
        
        XCTAssert(diff == 1 , "After insertion all entities count is not 1 more than count before insertion. Difference is \(diff)")
        
        let currentTemperature = try XCTUnwrap(storage.getEntity(with: entity.id)?.day.value)
        
        XCTAssertEqual(currentTemperature, day, "Temperature updated incorrectly")
    }
    
    func testInsertEntities() {
        
        let countBeforeInsertion = storage.getAll().count
        
        storage.insertEntities(entities)
        let countAfterInsertion = storage.getAll().count
        
        let diff = countAfterInsertion - countBeforeInsertion
        
        XCTAssert(diff == entities.count , "After insertion all entities count is not \(entities.count) more than count before insertion. Difference is \(diff)")
    }
    
    func testUpdateEntity() throws {
        let entity = TemperatureMock()
        var day: Float = -11
        entity.day.value = day
        
        let isInserted = storage.insertEntity(entity)
        
        XCTAssertTrue(isInserted, "Failed to insert temperature")
        
        day = 0
        
        let newEntity = TemperatureMock()
        newEntity.id = entity.id
        newEntity.day.value = day
        
        let isUpdated = storage.updateEntity(newEntity)
        
        XCTAssertTrue(isUpdated, "Failed to update temperature")
        
        let currentTemperature = try XCTUnwrap(storage.getEntity(with: entity.id)?.day.value)
        
        XCTAssertEqual(currentTemperature, day, "Temperature updated incorrectly")
    }
    
    func testRemoveEntity() {
        let entity = TemperatureMock()
        entity.day.value = -11
        
        let isInserted = storage.insertEntity(entity)
        
        XCTAssertTrue(isInserted, "Failed to insert temperature")

        let isRemoved = storage.removeEntity(entity)
        
        XCTAssertTrue(isRemoved, "Failed to remove entity")
    }
    
    func testRemoveEntityWithId() {
        let entity = TemperatureMock()
        entity.day.value = -11
        
        let isInserted = storage.insertEntity(entity)
        
        XCTAssertTrue(isInserted, "Failed to insert temperature")

        let isRemoved = storage.removeEntity(with: "\(entity.id)_1")
        
        XCTAssertFalse(isRemoved, "Removed entity which one didn`t exist")
    }
    
    func testRemoveAll() {
        
        let countBeforeInsertion = storage.getAll().count
        
        storage.insertEntities(entities)
        
        let newCount = storage.getAll().count
        XCTAssertEqual(newCount, countBeforeInsertion + entities.count, "Not all items inserted")
        
        storage.removeAll()
        
        let isAllItemsRemoved = storage.getAll().isEmpty
        
        XCTAssertTrue(isAllItemsRemoved, "There is unremoved items")
    }

}
