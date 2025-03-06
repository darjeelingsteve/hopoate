//
//  MockDependenciesTrait.swift
//  Hopoate
//
//  Created by Seb Skuse on 05/03/2025.
//

import Testing
import Hopoate

#if compiler(>=6.1)

/// A trait which provides a new, isolated `DependencyContainer` for each test.
public struct IsolatedDependenciesTrait: SuiteTrait, TestScoping {
    public func provideScope(for test: Test, testCase: Test.Case?, performing function: @Sendable () async throws -> Void) async throws {
        try await DependencyContainer.$shared.withValue(DependencyContainer()) {
            try await function()
        }
    }
}

public extension Trait where Self == IsolatedDependenciesTrait {
    
    /// A trait which provides a new, isolated `DependencyContainer` for each test.
    static var isolatedDependencies: Self {
        Self()
    }
}

#endif
