//
//  GameReducer.swift
//  Counter
//
//  Created by hong on 2023/02/26.
//

import Foundation
import ComposableArchitecture

public struct GameReducer: ReducerProtocol {
    public struct State: Equatable {
        var counter: CounterReducer.State = .init()
        var timer: TimerReducer.State = .init()
    }

    public enum Action {
        case counter(CounterReducer.Action)
        case timer(TimerReducer.Action)
    }

    public var body: some ReducerProtocol<State, Action> {
        Scope(state: \.counter, action: /Action.counter) {
            CounterReducer()
        }
        Scope(state: \.timer, action: /Action.timer) {
            TimerReducer()
        }
    }
}
