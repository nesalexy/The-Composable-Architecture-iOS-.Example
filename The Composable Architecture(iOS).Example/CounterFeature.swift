//
//  CounterFeature.swift
//  The Composable Architecture(iOS).Example
//
//  Created by Alexy Nesterchuk on 07.06.2024.
//

import ComposableArchitecture


@Reducer
struct CounterFeature {
    struct State {
        var count = 0
    }
    
    enum Action {
        case decrementButtonTapped
        case incrementButtonTapped
        case resetButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .decrementButtonTapped:
                state.count -= 1
                return .none
            case .incrementButtonTapped:
                state.count += 1
                return .none
            case .resetButtonTapped:
                state.count = 0
                return .none
            }
        }
    }
}
