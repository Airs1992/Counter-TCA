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
        var results = IdentifiedArrayOf<GameResult>()
    }

    public enum Action {
        case counter(CounterReducer.Action)
        case gameResultList(GameResultListReducer.Action)
    }

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .counter(.playNext):
              let result = GameResult(counter: state.counter)
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
    struct GameResult: Equatable, Identifiable {
        let counter: CounterReducer.State
        var correct: Bool { counter.secret == counter.count }
        var id: UUID { counter.id }
    }
}
