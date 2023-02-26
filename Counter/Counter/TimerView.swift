//
//  TimerView.swift
//  Counter
//
//  Created by hong on 2023/02/26.
//

import SwiftUI
import ComposableArchitecture

public struct TimerView: View {
    public let store: StoreOf<TimerReducer>
    public var body: some View {
        WithViewStore(store) { viewStore in
            VStack(alignment: .leading) {
                Label(
                    viewStore.started == nil ? "-" : "\(viewStore.started!.formatted(date: .omitted, time: .standard))",
                    systemImage: "clock"
                )
                Label(
                    "\(viewStore.duration, format: .number)s",
                    systemImage: "timer"
                )
            }
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static let store = Store(initialState: .init(), reducer: TimerReducer())
    static var previews: some View {
        VStack {
            WithViewStore(store) { viewStore in
                VStack {
                    TimerView(store: store)
                    HStack {
                        Button("Start") { viewStore.send(.start) }
                        Button("Stop") { viewStore.send(.stop) }
                    }.padding()
                }
            }
        }
    }
}
