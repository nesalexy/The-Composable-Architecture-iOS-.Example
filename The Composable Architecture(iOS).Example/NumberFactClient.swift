//
//  NumberFactClient.swift
//  The Composable Architecture(iOS).Example
//
//  Created by Alexy Nesterchuk on 08.06.2024.
//

import ComposableArchitecture
import Foundation

/// `Recommendation`:  We prefer to use structs with mutable properties
/// to represent the interface, and then construct values of the struct to represent conformances.

struct NumberFactClient {
    var fetch: (Int) async throws -> String
}

extension NumberFactClient: DependencyKey {
    static let liveValue = Self(
        fetch: { number in
            let (data, _) = try await URLSession.shared
                .data(from: URL(string: "http://numbersapi.com/\(number)")!)
            return String(decoding: data, as: UTF8.self)
        }
    )
}

extension DependencyValues {
    var numberFact: NumberFactClient {
        get { self[NumberFactClient.self] }
        set { self[NumberFactClient.self] = newValue }
    }
}

