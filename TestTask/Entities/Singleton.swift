//
// Created by Evgeny Plenkin on 28/03/2018.
// Copyright (c) 2018 Evgeny Plenkin. All rights reserved.
//

import Foundation

final class Singleton {
    private init() {}

    static private let manager: SingletonManager = { return SingletonManager() }()

    static func sharedInstance<T>(_ type: T.Type, initWithDefaultValue value: T? = nil) -> T? {
        return manager.sharedInstance(T.self, initWithDefaultValue: value)
    }

    static func create<T>(withValue value: T) -> T? {
        return manager.initSingleton(with: value)
    }
}

final class SingletonManager {

    //MARK: - NOT IDENTIFIABLE
    private var sharedInstances: [Any] = []

    func sharedInstance<T>(_ type: T.Type, initWithDefaultValue value: T?) -> T? {
        for instance in sharedInstances {
            if let value = instance as? T {
                return value
            }
        }

        if let defaultValue = value {
            return setValue(defaultValue)
        }

        return nil
    }

    @discardableResult
    func initSingleton<T>(with instance: T) -> T? {
        return setValue(instance)
    }

    @discardableResult
    private func setValue<T>(_ value: T) -> T {
        for (index, instance) in sharedInstances.enumerated() {
            if instance is T {
                sharedInstances[index] = value
                return value
            }
        }

        sharedInstances.append(value)

        return value
    }

    private func value<T>(withType type: T.Type) -> T? {
        for (index, instance) in sharedInstances.enumerated() {
            if instance is T {
                return instance as? T
            }
        }

        return nil
    }
}