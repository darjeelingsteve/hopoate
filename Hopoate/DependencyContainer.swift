//
//  DependencyContainer.swift
//  Hopoate
//
//  Created by Stephen Anthony on 19/09/2018.
//  Copyright © 2018 Darjeeling Apps. All rights reserved.
//

import Foundation

/// The container class used to register and resolve injectable dependencies. Multiple service providers can be registered for the same type; in this case, the most recent registration will be used when resolving a service.
public final class DependencyContainer {
    private var serviceProviderRegistrars = [ServiceProviderRegistrar]()
    
    public static let shared = DependencyContainer()
    
    /// Registers a creation closure for a given service type.
    ///
    /// - Parameters:
    ///   - service: The type of service that the creation closure returns.
    ///   - cacheService: Determines whether the result of calling the creator should be cached or not. Defaults to `true`.
    ///   - creator: The closure that will be executed when resolving a service of the given type.
    /// - Returns: The `ServiceRegistration` created during registration. Can be passed to the `remove` function to remove the registration.
    @discardableResult
    public func register<Service>(service: Service.Type, cacheService: Bool = true, creator: @escaping () -> Service) -> ServiceRegistration<Service> {
        return registrar(for: service).add(serviceCreator: creator, cacheService: cacheService)
    }
    
    /// Registers a service for a given service type.
    ///
    /// - Parameters:
    ///   - instance: The closure used to create the service that will be registered.
    ///   - service: The type of service that the `instance` closure returns.
    /// - Returns: The `ServiceRegistration` created during registration. Can be passed to the `remove` function to remove the registration.
    @discardableResult
    public func register<Service>(_ instance: @autoclosure @escaping () -> Service, for service: Service.Type) -> ServiceRegistration<Service> {
        return register(service: service, creator: instance)
    }
    
    /// - Parameter serviceType: The service type that we wish to find a service for.
    /// - Returns: A service instance that satisfies the given service type. Requesting a service for a service type that has not been registered is considered a programming error and will cause a fatal error.
    public func resolve<Service>(_ serviceType: Service.Type) -> Service {
        guard let service = optionalResolve(serviceType) else {
            fatalError("No service registered for \(String(describing: Service.self))")
        }
        
        return service
    }
    
    /// - Parameter serviceType: The service type that we wish to find a service for.
    /// - Returns: A service instance that satisfies the given service type, or nil if a service hasn't been registered for that type
    public func optionalResolve<Service>(_ serviceType: Service.Type) -> Service? {
        guard let registrarServiceRegistration = registrar(for: serviceType).mostRecentServiceEntry(), let serviceRegistration = registrarServiceRegistration as? ServiceRegistration<Service> else {
            return nil
        }
        
        return serviceRegistration.service
    }
    
    /// Removes the given service registration from the receiver, so that creation closure given at registration will not be invoked again.
    ///
    /// - Parameter serviceRegistration: The service registration to be removed.
    public func remove<Service>(_ serviceRegistration: ServiceRegistration<Service>) {
        registrar(for: serviceRegistration.serviceType).remove(serviceRegistration: serviceRegistration)
    }
    
    private func registrar<Service>(for type: Service.Type) -> ServiceProviderRegistrar {
        let registrationKey = String(describing: type)
        if let existingRegistrar = serviceProviderRegistrars.first(where: { $0.registrationKey == registrationKey }) {
            return existingRegistrar
        }
        let serviceProviderRegistrar = ServiceProviderRegistrar(registrationKey: registrationKey)
        serviceProviderRegistrars.append(serviceProviderRegistrar)
        return serviceProviderRegistrar
    }
}

/// Shorthand function to wrap DependencyContainer.shared
///
/// - Parameter serviceType: The service type that we wish to find a service for.
/// - Returns: A service instance that satisfies the given service type. Requesting a service for a service type that has not been registered is considered a programming error and will cause a fatal error.
public func resolve<Service>(_ serviceType: Service.Type) -> Service {
    return DependencyContainer.shared.resolve(serviceType)
}

/// Shorthand function to wrap DependencyContainer.shared
///
/// - Parameter serviceType: The service type that we wish to find a service for.
/// - Returns: A service instance that satisfies the given service type, or nil if a service hasn't been registered for that type
public func optionalResolve<Service>(_ serviceType: Service.Type) -> Service? {
    return DependencyContainer.shared.optionalResolve(serviceType)
}
