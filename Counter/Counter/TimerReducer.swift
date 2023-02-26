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

    @Dependency(\.date) var date
    @Dependency(\.mainQueue) var mainQueue

    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        struct TimerId: Hashable {}

        switch action {
        case .binding:
            return .none
        case .start:
            if state.started == nil {
                state.started = self.date.now
            }
            let timer = EffectTask.timer(id: TimerId(), every: .milliseconds(10), tolerance: .zero, on: mainQueue)
            return timer.map { time -> TimerReducer.Action in
                return TimerReducer.Action.timeUpdated
            }
        case .stop:
            return .cancel(id: TimerId())
        case .timeUpdated:
            state.duration += 0.01
            return .none
        }
    }
}
