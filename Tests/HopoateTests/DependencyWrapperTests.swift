//
//  DependencyWrapperTests.swift
//  Hopoate
//
//  Created by Stephen Anthony on 17/06/2025.
//

import Foundation
import Hopoate
import Testing

@Suite(.serialized)
final class DependencyWrapperTests {
    private static let specificContainer = DependencyContainer()
    
    @Dependency private var sharedContainerDependencyWrapper: TestClass
    @Dependency(container: specificContainer) private var specificContainerDependencyWrapper: TestClass
    @OptionalDependency private var sharedContainerOptionalDependencyWrapper: TestClass?
    @OptionalDependency(container: specificContainer) private var specificContainerOptionalDependencyWrapper: TestClass?
    
    private var sharedContainerServiceRegistration: ServiceRegistration<TestClass>!
    private var specificContainerServiceRegistration: ServiceRegistration<TestClass>!
    
    deinit {
        DependencyContainer.shared.remove(sharedContainerServiceRegistration)
        DependencyWrapperTests.specificContainer.remove(specificContainerServiceRegistration)
    }
    
    @Test("Dependency wrappers with no specified container use the shared container")
    func testDependencyWrapperWithNoSpecifiedContainer() {
        givenDependenciesAreRegisteredInTheSharedAndSpecificContainers()
        whenAMessageIsSentToTheDependency(inContainer: .shared)
        #expect(sharedContainerDependencyWrapper.receivedDoSomethingMessage == true)
        #expect(specificContainerDependencyWrapper.receivedDoSomethingMessage == false)
    }
    
    @Test("Optional dependency wrappers with no specified container use the shared container")
    func testOptionalDependencyWrapperWithNoSpecifiedContainer() {
        givenDependenciesAreRegisteredInTheSharedAndSpecificContainers()
        whenAMessageIsSentToTheDependency(inContainer: .shared)
        #expect(sharedContainerOptionalDependencyWrapper?.receivedDoSomethingMessage == true)
        #expect(specificContainerOptionalDependencyWrapper?.receivedDoSomethingMessage == false)
    }
    
    @Test("Dependency wrappers with a specified container use the specified container")
    func testDependencyWrapperWithSpecifiedContainer() {
        givenDependenciesAreRegisteredInTheSharedAndSpecificContainers()
        whenAMessageIsSentToTheDependency(inContainer: DependencyWrapperTests.specificContainer)
        #expect(sharedContainerDependencyWrapper.receivedDoSomethingMessage == false)
        #expect(specificContainerDependencyWrapper.receivedDoSomethingMessage == true)
    }
    
    @Test("Optional dependency wrappers with a specified container use the specified container")
    func testOptionalDependencyWrapperWithSpecifiedContainer() {
        givenDependenciesAreRegisteredInTheSharedAndSpecificContainers()
        whenAMessageIsSentToTheDependency(inContainer: DependencyWrapperTests.specificContainer)
        #expect(sharedContainerOptionalDependencyWrapper?.receivedDoSomethingMessage == false)
        #expect(specificContainerOptionalDependencyWrapper?.receivedDoSomethingMessage == true)
    }
    
    private func givenDependenciesAreRegisteredInTheSharedAndSpecificContainers() {
        sharedContainerServiceRegistration = DependencyContainer.shared.register(TestClass(), for: TestClass.self)
        specificContainerServiceRegistration = DependencyWrapperTests.specificContainer.register(TestClass(), for: TestClass.self)
    }
    
    private func whenAMessageIsSentToTheDependency(inContainer container: DependencyContainer) {
        container.resolve(TestClass.self).doSomething()
    }
}
