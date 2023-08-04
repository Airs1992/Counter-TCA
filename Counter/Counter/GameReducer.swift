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
        var resultList = GameResultListReducer.State(results: IdentifiedArrayOf<GameReducer.GameResult>())
        var selectionResultList: Identified<UUID, GameResultListReducer.State>?
    }

    public enum Action {
        case counter(CounterReducer.Action)
        case gameResultList(GameResultListReducer.Action)
        case setNavigation(UUID?)
    }

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .counter(.playNext):
              let result = GameResult(counter: state.counter)
              state.resultList.results.append(result)
              return .none
            case .setNavigation(.some(let id)):
              state.selectionResultList = .init(state.resultList, id: id)
              return .none
            case .setNavigation(.none):
              state.resultList.results = state.selectionResultList?.value.results ?? []
              state.selectionResultList = nil
              return .none
            default:
              return .none
            }
        }
        Scope(state: \.counter, action: /Action.counter) {
            CounterReducer()
        }
        .ifLet(\State.selectionResultList, action: /Action.gameResultList) {
            Scope(state: \Identified<UUID, GameResultListReducer.State>.value, action: .self) {
                GameResultListReducer()
            }
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
