//
//  Container.swift
//  ZeroDI
//
//  Created by Philipp Kotte on 05.07.25.
//


import Foundation

/// A simple Dependency Injection (DI) container for managing services.
@objc public final class Container: NSObject {
    /// A closure that creates a service instance.
    public typealias ServiceFactory = (Container) -> Any
    
    private var services: [String: ServiceFactory] = [:]
    private var servicesFor: [String: ServiceFactory] = [:]

    public override init() {}

    /// Registers a service with the container.
    ///
    /// - Parameters:
    ///   - type: The protocol or type of the service to register.
    ///   - factory: A closure that creates an instance of the service.
    public func register<Service>(_ type: Service.Type, factory: @escaping ServiceFactory) {
        let key = String(describing: type)
        services[key] = factory
    }
    
    public func register<Service, Target>(_ type: Service.Type, target: Target.Type, factory: @escaping ServiceFactory) {
        let key = String(describing: type) + String(describing: target)
        servicesFor[key] = factory
    }

    /// Resolves and returns an instance of a registered service.
    ///
    /// This method will crash with a `fatalError` if the service is not registered,
    /// ensuring that all dependencies are explicitly declared.
    ///
    /// - Parameter type: The protocol or type of the service to resolve.
    /// - Returns: An instance of the service.
    public func resolve<Service>(_ type: Service.Type) -> Service {
        let key = String(describing: type)
        guard let factory = services[key], let service = factory(self) as? Service else {
            fatalError("Service '\(key)' not registered.")
        }
        return service
    }
    
    public func resolve<Service, Target>(_ type: Service.Type, target: Target.Type) -> Service {
        let key = String(describing: type) + String(describing: target)
        guard let factory = servicesFor[key], let service = factory(self) as? Service else {
            fatalError("Service '\(key)' not registered.")
        }
        return service
    }
}
