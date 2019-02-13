//
//  DependencyContainerTests.swift
//  HopoateTests
//
//  Created by Stephen Anthony on 19/09/2018.
//  Copyright © 2018 Darjeeling Apps. All rights reserved.
//

@testable import Hopoate
import XCTest

class DependencyContainerTests: XCTestCase {
    var dependencyContainer: DependencyContainer!
    
    override func setUp() {
        super.setUp()
        dependencyContainer = DependencyContainer()
    }
    
    override func tearDown() {
        dependencyContainer = nil
        super.tearDown()
    }
    
    func testItAlwaysReturnsTheSameInstanceAsItsSharedInstance() {
        let instanceOne = DependencyContainer.shared
        let instanceTwo = DependencyContainer.shared
        XCTAssertTrue(instanceOne === instanceTwo)
    }
    
    func testItRegistersAndResolvesASingleService() {
        let object = TestClass()
        dependencyContainer.register(service: TestProtocol.self) {
            return object
        }
        
        dependencyContainer.resolve(TestProtocol.self).doSomething()
        XCTAssertTrue(object.receivedDoSomethingMessage)
    }
    
    func testItResolvesTheMostRecentlyRegisteredService() {
        let objectOne = TestClass()
        let objectTwo = TestClass()
        dependencyContainer.register(service: TestProtocol.self) {
            return objectOne
        }
        dependencyContainer.register(service: TestProtocol.self) {
            return objectTwo
        }
        
        dependencyContainer.resolve(TestProtocol.self).doSomething()
        XCTAssertFalse(objectOne.receivedDoSomethingMessage)
        XCTAssertTrue(objectTwo.receivedDoSomethingMessage)
    }
    
    func testItAllowsServiceRegistrationsToBeRemoved() {
        let objectOne = TestClass()
        let objectTwo = TestClass()
        dependencyContainer.register(service: TestProtocol.self) {
            return objectOne
        }
        let objectTwoRegistration = dependencyContainer.register(service: TestProtocol.self) {
            return objectTwo
        }
        dependencyContainer.remove(objectTwoRegistration)
        
        dependencyContainer.resolve(TestProtocol.self).doSomething()
        XCTAssertTrue(objectOne.receivedDoSomethingMessage)
        XCTAssertFalse(objectTwo.receivedDoSomethingMessage)
    }
    
    func testItCanOptionallyResolveAService() {
        XCTAssertNil(dependencyContainer.optionalResolve(TestProtocol.self))
        let objectOne = TestClass()
        dependencyContainer.register(service: TestProtocol.self) {
            return objectOne
        }
        dependencyContainer.optionalResolve(TestProtocol.self)?.doSomething()
        XCTAssertTrue(objectOne.receivedDoSomethingMessage)
    }
    
    func testItDeterminesWhetherAServiceCanBeResolvedOrNot() {
        XCTAssertFalse(dependencyContainer.canResolve(TestProtocol.self))
        dependencyContainer.register(service: TestProtocol.self) {
            TestClass()
        }
        XCTAssertTrue(dependencyContainer.canResolve(TestProtocol.self))
    }
}

// MARK: - Caching
extension DependencyContainerTests {
    func testItCreatesANewServiceEachTimeWhenCachingIsDisabled() {
        dependencyContainer.register(service: TestProtocol.self, cacheService: false) {
            TestClass()
        }
        
        let firstService = dependencyContainer.resolve(TestProtocol.self)
        let secondService = dependencyContainer.resolve(TestProtocol.self)
        XCTAssertFalse(firstService === secondService)
    }
    
    func testItDoesNotCreateANewServiceEachTimeWhenCachingIsEnabled() {
        dependencyContainer.register(service: TestProtocol.self, cacheService: true) {
            TestClass()
        }
        
        let firstService = dependencyContainer.resolve(TestProtocol.self)
        let secondService = dependencyContainer.resolve(TestProtocol.self)
        XCTAssertTrue(firstService === secondService)
    }
}

protocol TestProtocol: class {
    func doSomething()
}

class TestClass: TestProtocol {
    private(set) var receivedDoSomethingMessage = false
    
    func doSomething() {
        receivedDoSomethingMessage = true
    }
}
