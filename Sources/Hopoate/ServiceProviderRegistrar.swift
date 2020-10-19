//
//  ServiceProviderRegistrar.swift
//  Hopoate
//
//  Created by Stephen Anthony on 19/09/2018.
//  Copyright © 2018 Darjeeling Apps. All rights reserved.
//

import Foundation

/// Used to track the `ServiceRegistration`s for a particular service type.
final class ServiceProviderRegistrar {
    
    /// The key used to identify the type of service registered with the receiver.
    let registrationKey: String
    private var serviceRegistrations = [AnyObject]()
    
    init(registrationKey: String) {
        self.registrationKey = registrationKey
    }
    
    /// Registers the creation closure for creating a service.
    ///
    /// - Parameter serviceCreator: The closure that creates a service.
    /// - cacheService: Determines whether the result of calling the creator should be cached or not
    /// - Returns: The individual registration instance that represents this addition.
    func add<Service>(serviceCreator: @escaping () -> Service, cacheService: Bool) -> ServiceRegistration<Service> {
        let serviceRegistration = ServiceRegistration(serviceType: Service.self, creator: serviceCreator, cacheService: cacheService)
        serviceRegistrations.append(serviceRegistration)
        return serviceRegistration
    }
    
    /// Removes the given service registration so that its creation closure will not be invoked in future.
    ///
    /// - Parameter serviceRegistration: The service registration to be removed from the receiver.
    func remove<Service>(serviceRegistration: ServiceRegistration<Service>) {
        guard let index = serviceRegistrations.firstIndex(where: { $0 === serviceRegistration }) else {
            return
        }
        serviceRegistrations.remove(at: index)
    }
    
    /// Removes all services registered with the receiver.
    func removeAllRegistrations() {
        serviceRegistrations.removeAll()
    }
    
    /// - Returns: The most recent service registration added to the receiver.
    func mostRecentServiceEntry() -> AnyObject? {
        return serviceRegistrations.last
    }
}
