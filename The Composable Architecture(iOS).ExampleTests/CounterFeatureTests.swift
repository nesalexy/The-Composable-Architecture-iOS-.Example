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
final class CounterFeatureTests: XCTestCase { }

// MARK: - Testing regular cases
extension CounterFeatureTests {
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
        
        /// `store.exhaustivity = .off`
        /// test the integration of many complex features,
        /// without needing to assert on everything in the feature. Example bellow
//        store.exhaustivity = .off
//        await store.send(.incrementButtonTapped)
//        await store.send(.decrementButtonTapped) {
//            $0.count = 0
//        }
        
        /// another example with using XCTAssertEqual
//        store.exhaustivity = .off
//        await store.send(.incrementButtonTapped) {
//            XCTAssertEqual($0.count, 1)
//        }
//        await store.send(.decrementButtonTapped) {
//            $0.count = 0
//        }
    }
}

// MARK: - Testing effects
extension CounterFeatureTests {
    func testTimer() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        }
        
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerRunning = true
        }
        
        await store.receive(\.timerTick) {
            $0.count = 1
        }
        
        await store.receive(\.timerTick) {
            $0.count = 2
        }
        
        await store.receive(\.timerTick) {
            $0.count = 3
        }
        
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerRunning = false
        }
    }
}


// MARK: - Testing network requests
extension CounterFeatureTests {
    func testNumberFact() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.numberFact.fetch = { "\($0)" }
        }
        
        await store.send(.factButtonTapped) {
            $0.isLoading = true
        }
        
        await store.receive(\.factResponse, timeout: .seconds(1)) {
            $0.isLoading = false
            $0.fact = "0"
        }
        
    }
}
