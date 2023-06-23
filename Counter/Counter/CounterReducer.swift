//
//  CounterReducer.swift
//  Counter
//
//  Created by hong on 2023/02/21.
//

import ComposableArchitecture
import Foundation

public struct CounterReducer: ReducerProtocol {
    public struct State: Equatable, Identifiable {
        public var id: UUID = UUID()
        var secret = Int.random(in: -100 ... 100)
        var count = 0
    }

    public enum Action: Equatable {
        case increment
        case decrement
        case setCount(String)
        case reset
        case playNext
    }

//    @Dependency(\.generateRandom) var generateRandom


    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .decrement:
                state.count -= 1
                return .none
            case .increment:
                state.count += 1
                return .none
            case .reset:
                state.count = 0
                return .none
            case .setCount(let text):
                state.countString = text
                return .none
            case .playNext:
                state.count = 0
                state.secret = Int.random(in: -100 ... 100)
//                state.secret = generateRandom.generateRandomInt(-100 ... 100)
                return .none
            }
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
