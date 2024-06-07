//
//  The_Composable_Architecture_iOS__ExampleApp.swift
//  The Composable Architecture(iOS).Example
//
//  Created by Alexy Nesterchuk on 07.06.2024.
//

import SwiftUI
import ComposableArchitecture

@main
struct The_Composable_Architecture_iOS__ExampleApp: App {
    static let store = Store(initialState: CounterFeature.State()) {
        CounterFeature()
            ._printChanges()
    }
    
    var body: some Scene {
        WindowGroup {
            CounterView(
                store: The_Composable_Architecture_iOS__ExampleApp.store
            )
        }
    }
}
