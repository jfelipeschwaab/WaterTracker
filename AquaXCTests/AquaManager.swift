//
//  AquaXCTests.swift
//  AquaXCTests
//
//  Created by João Felipe Schwaab on 06/03/26.
//

import XCTest
@testable import Aqua
import SwiftData

// MARK: - Test Doubles

final class MockDataBase: DataBaseProtocol {
    // Tracking
    private(set) var added: [Any] = []
    private(set) var updated: [Any] = []
    private(set) var deleted: [Any] = []

    // Stubs keyed by type name
    var stubbedFetchResults: [String: Any] = [:]

    func add<T: PersistentModel>(element: T) {
        added.append(element)
    }

    func delete<T: PersistentModel>(element: T) {
        deleted.append(element)
    }

    func update<T: PersistentModel>(element: T) {
        updated.append(element)
    }

    func getAllElements<T: PersistentModel>(fetchDescriptor: FetchDescriptor<T>) -> [T] {
        let key = String(reflecting: T.self)
        if let any = stubbedFetchResults[key] as? [T] {
            return any
        }
        return []
    }
}

final class AquaXCTests: XCTestCase {

    // System Under Test
    private var sut: WaterManager!
    // Collaborators
    private var dataController: MockDataBase!

    override func setUpWithError() throws {
        //Arrange
        try super.setUpWithError()
        dataController = MockDataBase()
        sut = WaterManager(dataController: dataController)
    }

    override func tearDownWithError() throws {
        sut = nil
        dataController = nil
        try super.tearDownWithError()
    }

    func test_CreateRegister() throws {
        
        //Act
        sut.createRegister()
        
        //Assert
        XCTAssertEqual(dataController.added.count, 2)
    }
    
    func test_UpdateGoalAmount() throws {
        
        //Act
        sut.updateGoalAmount(to: 2400)
        
        //Assert
        XCTAssertEqual(sut.registerOfTheDay?.goalAmount, 2400)
    }
    
    
    func test_updateTotalAmount() throws {
        
        //Arrange
        sut.valueToAlwaysAdd = 200
        
        //Act
        sut.updateTotalAmount()
        
        //Assert
        XCTAssertEqual(sut.registerOfTheDay?.totalAmount, 200)
    }
    
    func test_updateValueToAlwaysAdd() throws {
        
        //Act
        sut.updateValueToAlwaysAdd(400)
        
        //Assert
        XCTAssertEqual(sut.valueToAlwaysAdd, 400)
    }
    
    func test_resetProgress() throws {
        
        //Arrange
        sut.registerOfTheDay?.totalAmount = 1000
        
        //Act
        sut.resetProgress()
        
        XCTAssert(sut.registerOfTheDay?.totalAmount == 0)
    }
    
    func test_getProgressInPercentage() throws {
        
        //Arrange
        sut.registerOfTheDay?.goalAmount = 1000
        sut.registerOfTheDay?.totalAmount = 500
        
        //Act
        let progress_in_percentage : Double = sut.getProgress()
        
        //Assert
        XCTAssert(progress_in_percentage == 0.5)
    }
}
