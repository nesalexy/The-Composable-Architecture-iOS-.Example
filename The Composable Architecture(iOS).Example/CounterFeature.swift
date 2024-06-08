//
//  CounterFeature.swift
//  The Composable Architecture(iOS).Example
//
//  Created by Alexy Nesterchuk on 07.06.2024.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct CounterFeature {
    struct State: Equatable {
        var count = 0
        
        var fact: String?
        var isLoading = false
    }
    
    enum Action {
        case decrementButtonTapped
        case incrementButtonTapped
        case resetButtonTapped
        
        /// making request. `Side Effect`
        case factButtonTapped
        
        /// response. `Side Effect`
        case factResponse(fact: String)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .decrementButtonTapped:
                state.count -= 1
                state.fact = nil
                return .none
            case .incrementButtonTapped:
                state.count += 1
                state.fact = nil
                return .none
            case .resetButtonTapped:
                state.count = 0
                state.fact = nil
                return .none
            
            /// `Side Effect`. Request
            case .factButtonTapped:
                state.fact = nil
                state.isLoading = true
                
                /// `Side Effect`
                /// can be replaced by publisher
                return .run { [count = state.count] send in
                    /// async work
                    let (data, _) = try await URLSession.shared
                                .data(from: URL(string: "http://numbersapi.com/\(count)")!)
                    let fact = String(decoding: data, as: UTF8.self)
                    
                    /// send - @MainActor, need call with `await`
                    await send(.factResponse(fact: fact))
                }
                
            /// `Side Effect`. Response
            case .factResponse(let fact):
                state.isLoading = false
                state.fact = fact
                return .none
            }
        }
    }
}

struct CounterView: View {
    let store: StoreOf<CounterFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                Text("\(viewStore.count)")
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
                HStack {
                    Button("-") {
                        viewStore.send(.decrementButtonTapped)
                    }
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
                    
                    Button("+") {
                        viewStore.send(.incrementButtonTapped)
                    }
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
                    
                    Button("Reset") {
                        viewStore.send(.resetButtonTapped)
                    }
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.1))
                    .cornerRadius(10)
                }
                Button("Fact") {
                    viewStore.send(.factButtonTapped)
                }
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
                
                if viewStore.isLoading {
                    ProgressView()
                } else if let fact = viewStore.fact {
                    Text(fact)
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            }
        }
    }
}


#Preview {
    CounterView(
        store: Store(initialState: CounterFeature.State()) {
            CounterFeature()
        }
    )
}
