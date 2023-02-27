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
        var results = IdentifiedArrayOf<GameResult>()
        var lastTimestamp = 0.0
    }

    public enum Action {
        case counter(CounterReducer.Action)
        case timer(TimerReducer.Action)
    }

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .counter(.playNext):
                let result = GameResult(counter: state.counter, timeSpent: state.timer.duration - state.lastTimestamp)
                state.results.append(result)
                state.lastTimestamp = state.timer.duration
                return .none
            default:
                return .none
            }
        }
        Scope(state: \.counter, action: /Action.counter) {
            CounterReducer()
        }
        Scope(state: \.timer, action: /Action.timer) {
            TimerReducer()
        }
    }
}

extension GameReducer {
    struct GameResult: Equatable, Identifiable {
        let counter: CounterReducer.State
        let timeSpent: TimeInterval
        var correct: Bool { counter.secret == counter.count }

        var id: UUID { counter.id }
    }
}
