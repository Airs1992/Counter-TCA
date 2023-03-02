//
//  GameResultListViewReducer.swift
//  Counter
//
//  Created by hong on 2023/02/27.
//

import Foundation
import ComposableArchitecture

public struct GameResultListReducer: ReducerProtocol {
    public struct State: Equatable, Identifiable {
        public var id: UUID = UUID()
        var results = IdentifiedArrayOf<GameReducer.GameResult>()
    }
    
    public enum Action {
      case remove(offset: IndexSet)
    }

    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .remove(let offset):
            state.results.remove(atOffsets: offset)
        return .none
        }
    }
}
