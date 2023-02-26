//
//  TimerReducer.swift
//  Counter
//
//  Created by hong on 2023/02/26.
//

import ComposableArchitecture
import Foundation

public struct TimerReducer: ReducerProtocol {
    public struct State: Equatable {
        var started: Date? = nil
        var duration: TimeInterval = 0
    }

    public enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case start
        case stop
        case timeUpdated
    }

    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .binding:
            return .none
        case .start:
            fatalError("Not implemented")
        case .stop:
            fatalError("Not implemented")
        case .timeUpdated:
            state.duration += 0.01
            return .none
        }
    }
}
