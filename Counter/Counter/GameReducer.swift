//
//  GameReducer.swift
//  Counter
//
//  Created by hong on 2023/08/04.
//

import ComposableArchitecture
import Foundation

public struct GameReducer: ReducerProtocol {
    public struct State: Equatable {
        var counter: CounterReducer.State = .init()
        var results: [GameResult] = []
    }

    public enum Action {
        case counter(CounterReducer.Action)
    }

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .counter(.playNext):
              let result = GameResult(secret: state.counter.secret, guess: state.counter.count)
              state.results.append(result)
              return .none
            default:
              return .none
            }
        }
        Scope(state: \.counter, action: /Action.counter) {
            CounterReducer()
        }
    }
}

extension GameReducer {
    struct GameResult: Equatable {
        let secret: Int
        let guess: Int
        var correct: Bool { secret == guess }
    }
}
