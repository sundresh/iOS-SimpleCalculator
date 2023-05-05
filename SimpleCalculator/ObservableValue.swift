//
//  ObservableValue.swift
//  SimpleCalculator
//
//  Created by Sameer Sundresh on 5/4/23.
//

import Foundation

/// ObservableValue is an ObservableObject wrapper for a generic value. It can be instantiated in a
/// SwiftUI view with the @ObservedObject property wrapper to create an independently referenceable
/// value that SwiftUI can observe. This allows you to pass closures that manipulate state to other
/// initializers from a custom View's initializer (since you can't reference self from an escaping
/// closure in an initializer).
class ObservableValue<T>: ObservableObject {
    @Published var value: T

    init(_ value: T) {
        self.value = value
    }
}
