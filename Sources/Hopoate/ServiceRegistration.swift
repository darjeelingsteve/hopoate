//
//  ServiceRegistration.swift
//  Hopoate
//
//  Created by Stephen Anthony on 19/09/2018.
//  Copyright © 2018 Darjeeling Apps. All rights reserved.
//

import Foundation

/// Represents the registration of an individual service creator for a given service type.
public final class ServiceRegistration<Service> {
    let serviceType: Service.Type
    private let serviceCreation: ServiceCreation<Service>
    
    /// - Parameters:
    ///   - serviceType: The type of the service the creator is to be registered for.
    ///   - creator: The closure that creates an instance of `Service`.
    ///   - cacheService: Determines whether the result of calling the creator should be cached or not.
    init(serviceType: Service.Type, creator: @escaping () -> Service, cacheService: Bool) {
        self.serviceType = serviceType
        if cacheService {
            serviceCreation = .cached(service: creator())
        } else {
            serviceCreation = .uncached(creator: creator)
        }
    }
    
    /// The result of calling the creator closure the receiver was initialised with.
    var service: Service {
        switch serviceCreation {
        case .cached(let service):
            return service
        case .uncached(let creator):
            return creator()
        }
    }
}

/// The different service creation types used by `ServiceRegistration`.
///
/// - cached: A service instance has been cached, so always use the cached instance.
/// - uncached: No service instance has been cached, so return a new instance when a service is requested.
private enum ServiceCreation<Service> {
    case cached(service: Service)
    case uncached(creator: () -> Service)
}
