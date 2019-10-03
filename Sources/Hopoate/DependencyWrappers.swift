//
//  DependencyWrappers.swift
//  Hopoate
//
//  Created by Seb Skuse on 16/07/2019.
//  Copyright © 2019 Darjeeling Apps. All rights reserved.
//

import Foundation

#if swift(>=5.1)

/// Wraps a required injected dependency using the default container.
///
/// Example: @Dependency var someDependency: SomeDependency
@propertyWrapper
public struct Dependency<T> {
    
    public init() {}
    
    public lazy var wrappedValue: T = resolve(T.self)
}

/// Wraps an optional injected dependency using the default container.
///
/// Example: @OptionalDependency var basketManager: BasketManaging
@propertyWrapper
public struct OptionalDependency<T> {
    
    public init() {}
    
    public lazy var wrappedValue: T? = optionalResolve(T.self)
}

#endif
