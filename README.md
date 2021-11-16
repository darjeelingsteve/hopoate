![](Images/Banner.png)



# [![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/Carthage/Carthage/master/LICENSE.md) [![Swift 5.0](https://img.shields.io/badge/Swift-5.0-orange.svg?style=flat)](https://swift.org/) [![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Hopoate is a lightweight dependency injection framework for iOS, allowing for simple registration and resolution of application dependencies.



### Dependency Registration

Registering a dependency is as simple as calling a single function on Hopoate's shared container:

```swift
DependencyContainer.shared.register(AnalyticsProvider(), for: AnalyticsProviding.self)
```

Here we have registered an instance of `AnalyticsProvider` for the `AnalyticsProviding` protocol. This `AnalyticsProvider` instance is cached by the container and will be returned whenever the container is asked for a dependency matching `AnalyticsProviding`.



### Dependency Resolution

Resolving a dependency is similarly simple:

```swift
let analyticsProvider = DependencyContainer.shared.resolve(AnalyticsProviding.self)
```

This resolves the dependency conforming to `AnalyticsProviding` that we registered earlier.

As a convenience, a property wrapper is provided to resolve dependencies automatically:

```swift
@Dependency private var analyticsProviding: AnalyticsProviding
```

This property accesses the equivalent of `DependencyContainer.shared.resolve(AnalyticsProviding.self)`. 



### Optional Dependency Resolution

For dependencies that may not always be registered, an `optionalResolve` function is provided:

```swift
let optionalDependency = DependencyContainer.shared.optionalResolve(Maybe.self)
optionalDependency?.perhaps()
```

These can also be accessed using a property wrapper:

```swift
@OptionalDependency private var maybe: Maybe?
```



### Unregistering Dependencies

When a dependency is registered, an opaque registration token is returned, which can be used later to remove the registration from the container:

```swift
let token = DependencyContainer.shared.register(service: AnalyticsProviding.self) {
    return AnalyticsProvider()
}

/**
Perform work that depends on the registered dependency
*/

DependencyContainer.shared.remove(token)
```



### Testing

Hopoate is great for unit testing, as it operates using a LIFO system for dependency resolution i.e the most recently registered dependency for a given type is the one returned when dependency resolution is requested. This allows for mock implementations to be registered with the container for the purposes of testing, which can be removed when the test is over. Once the mock dependency is removed, any previously registered dependency for the requested type will be resolved instead.

```swift
let mockLogger = MockLogger()
let token = DependencyContainer.shared.register(service: LogProviding.self) {
    return mockLogger
}

testedObject.doSomethingThatLogs()
XCTAssertTrue(mockLogger.receivedLogMessage)

DependencyContainer.shared.remove(token)
```



### Dependency Caching

By default, when a service is registered with the dependency container, the container caches the service that is given in the creation closure.

```swift
DependencyContainer.shared.register(service: AnalyticsProviding.self) {
    return AnalyticsProvider() // <- This object will be returned by all calls to DependencyContainer.shared.resolve(AnalyticsProviding.self)
}
```

If you do not want this caching behaviour, it can be disabled when registering the dependency:

```swift
DependencyContainer.shared.register(service: AnalyticsProviding.self, cacheService: false) {
    return AnalyticsProvider() // <- A new instance of AnalyticsProvider will be provided to each call to DependencyContainer.shared.resolve(AnalyticsProviding.self)
}
```



### Shorthand Functions

Two shorthand functions are provided for resolving dependencies to reduce the amount of code needed at the call site when requesting dependency resolution from the shared container:

```swift
// Shorthand for DependencyContainer.shared.resolve(AnalyticsProviding.self)
resolve(AnalyticsProviding.self)

// Shorthand for DependencyContainer.shared.optionalResolve(Maybe.self)
optionalResolve(Maybe.self)
```



## Installation

### Swift Package Manager

Add the following to your package's dependencies in your package manifest:

```swift
.package(name: "Hopoate", url: "https://github.com/darjeelingsteve/hopoate", from: "1.0.0"),
```



### Carthage

Add the following to your `Cartfile`:

```
github "darjeelingsteve/Hopoate"
```

