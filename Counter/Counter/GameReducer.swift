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
        var resultList: GameResultListReducer.State = .init()
        var lastTimestamp = 0.0

        // これを入れるによって、GameResultListReducer.Stateは二個あります
        // 自分表示用とプッシュ表示用に分けます
        var resultListState: Identified<UUID, GameResultListReducer.State>?
    }

    public enum Action {
        case counter(CounterReducer.Action)
        case timer(TimerReducer.Action)
        case resultList(GameResultListReducer.Action)
        case setNavigation(UUID?)
    }

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .counter(.playNext):
                let result = GameResult(counter: state.counter, timeSpent: state.timer.duration - state.lastTimestamp)
                state.resultList.results.append(result)
                state.lastTimestamp = state.timer.duration
                return .none
            case .setNavigation(.some(let id)):
                state.resultListState = .init(state.resultList, id: id)
                return .none
            case .setNavigation(.none):
                state.resultList.results = state.resultListState?.value.results ?? []
                state.resultListState = nil
                return .none
            default:
                return .none
            }
        }
        // 子のreducerに入れる前オプショナルの判定を先にやる、非nilの場合子reducerの処理を実行する
        .ifLet(\State.resultListState, action: /Action.resultList) {
            Scope(state: \Identified<UUID, GameResultListReducer.State>.value, action: .self) {
                GameResultListReducer()
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
    public struct GameResult: Equatable, Identifiable {
        let counter: CounterReducer.State
        let timeSpent: TimeInterval
        var correct: Bool { counter.secret == counter.count }

        public var id: UUID { counter.id }
    }
}
