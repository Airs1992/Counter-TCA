//
//  GameResultListViewReducer.swift
//  Counter
//
//  Created by hong on 2023/08/04.
//

import ComposableArchitecture
import Foundation

public struct GameResultListReducer: ReducerProtocol {
    public struct State: Equatable {
        var results = IdentifiedArrayOf<GameReducer.GameResult>()
    }

    public enum Action {
        case remove(offset: IndexSet)
    }

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .remove(let offset):
                state.results.remove(atOffsets: offset)
                return .none
            }
        }
    }
}
