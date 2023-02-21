//
//  CounterReducer.swift
//  Counter
//
//  Created by hong on 2023/02/21.
//

import ComposableArchitecture

public struct CounterReducer: ReducerProtocol {
    public struct State: Equatable {
        var count = 0
    }

    public enum Action {
        case increment
        case decrement
    }

    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .decrement:
            state.count -= 1
            return .none
        case .increment:
            state.count += 1
            return .none
        }
    }
}
