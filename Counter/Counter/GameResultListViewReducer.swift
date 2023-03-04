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
        var results = IdentifiedArrayOf<CounterReducer.State>()
        var selection: Identified<CounterReducer.State.ID, CounterReducer.State?>?
    }
    
    public enum Action {
        case remove(offset: IndexSet)
        case row(id: CounterReducer.State.ID, action: CounterReducer.Action)
        case setNavigation(selection: UUID?)
        case counter(CounterReducer.Action)
    }

    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .remove(let offset):
                state.results.remove(atOffsets: offset)
                return .none
            case .row:
                return .none
            case let .setNavigation(selection: .some(id)):
                state.selection = Identified(nil, id: id)
                return .none
            case .setNavigation(selection: .none):
                state.selection = nil
                return .none
            case .counter:
                return .none
            }
        }
        .ifLet(\State.selection, action: /Action.counter) {
          EmptyReducer()
                .ifLet(\Identified<CounterReducer.State.ID, CounterReducer.State?>.value, action: .self) {
              CounterReducer()
            }
        }
        .forEach(\.results, action: /Action.row(id:action:)) {
            CounterReducer()
        }
    }
}
