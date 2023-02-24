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
        var colorHex = 0x000000
    }

    public enum Action: Equatable {
        case increment
        case decrement
        case setCount(String)
        case changeCountColor(Int)
        case reset
    }

    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .decrement:
            state.count -= 1
            return .send(.changeCountColor(state.count))
        case .increment:
            state.count += 1
            return .send(.changeCountColor(state.count))
        case .reset:
            state.count = 0
            state.colorHex = 0x000000
            return .none
        case .changeCountColor(let count):
            if count > 0 {
                state.colorHex = 0x00FF00
            } else if count < 0 {
                state.colorHex = 0xFF0000
            } else {
                state.colorHex = 0x000000
            }
            return .none
        case .setCount(let text):
            state.countString = text
            return .none
        }
    }
}

extension CounterReducer.State {
  var countString: String {
    get { String(count) }
    set { count = Int(newValue) ?? count }
  }
}
