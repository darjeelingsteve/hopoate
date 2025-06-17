//
//  DependencyWrappers.swift
//  Hopoate
//
//  Created by Seb Skuse on 16/07/2019.
//  Copyright © 2019 Darjeeling Apps. All rights reserved.
//

import Foundation

#if swift(>=5.1)

/// Wraps a required injected dependency using the specified container. If no
/// container is specified then the `shared` container is used.
///
/// Example: @Dependency var someDependency: SomeDependency
@propertyWrapper
public struct Dependency<T> {
    private let container: DependencyContainer
    
    public init(container: DependencyContainer = .shared) {
        self.container = container
    }
    
    public lazy var wrappedValue: T = container.resolve(T.self)
}

/// Wraps an optional injected dependency using the specified container. If no
/// container is specified then the `shared` container is used.
///
/// Example: @OptionalDependency var basketManager: BasketManaging
@propertyWrapper
public struct OptionalDependency<T> {
    private let container: DependencyContainer
    
    public init(container: DependencyContainer = .shared) {
        self.container = container
    }
    
    public lazy var wrappedValue: T? = container.optionalResolve(T.self)
}

#endif
