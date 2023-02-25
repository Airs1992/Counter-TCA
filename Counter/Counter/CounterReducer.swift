//
//  CounterReducer.swift
//  Counter
//
//  Created by hong on 2023/02/21.
//

import ComposableArchitecture

public struct CounterReducer: ReducerProtocol {
    public struct State: Equatable {
        var secret = Int.random(in: -100 ... 100)
        var count = 0
        var colorHex = 0x000000
        // @BindingStatとBindableAction、case binding(BindingAction<State>)入れるとアクション追加しなくてもBindingは成立します。
        @BindingState var toggleState: Bool = false
    }

    public enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case increment
        case decrement
        case slidingCount(Float)
        case setCount(String)
        case changeCountColor(Int)
        case setToggleState(Bool)
        case reset
        case playNext
    }

    @Dependency(\.generateRandom) var generateRandom

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
        case .slidingCount(let value):
            state.countFloat = value
            return .none
        case .setCount(let text):
            state.countString = text
            return .send(.setToggleState(text.count >= 1))
        case .binding:
            return .none
        case .setToggleState(let flag):
            state.toggleState = flag
            return .none
        case .playNext:
            state.count = 0
            state.colorHex = 0x000000
            state.secret = generateRandom.generateRandomInt(-100 ... 100)
            return .none
        }
    }
}

extension CounterReducer.State {
    var countFloat: Float {
      get { Float(count) }
      set { count = Int(newValue) }
    }
}

extension CounterReducer.State {
    var countString: String {
        get { String(count) }
        set { count = Int(newValue) ?? count }
    }
}

extension CounterReducer.State {
    enum CheckResult {
        case lower, equal, higher
    }
    var checkResult: CheckResult {
        if count < secret { return .lower }
        if count > secret { return .higher }
        return .equal
    }
}
