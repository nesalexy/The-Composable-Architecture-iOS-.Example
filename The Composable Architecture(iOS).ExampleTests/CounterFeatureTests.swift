//
//  CounterFeatureTests.swift
//  The Composable Architecture(iOS).ExampleTests
//
//  Created by Alexy Nesterchuk on 08.06.2024.
//

@testable import The_Composable_Architecture_iOS__Example
import ComposableArchitecture
import XCTest

/// I'm impressed with the way the tests are made
@MainActor
final class CounterFeatureTests: XCTestCase {
    
    /// testing regular value
    func testCounter() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        }
        
        await store.send(.incrementButtonTapped) {
            $0.count = 1
        }
        await store.send(.decrementButtonTapped) {
            $0.count = 0
        }
    }
}

