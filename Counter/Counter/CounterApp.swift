//
//  CounterApp.swift
//  Counter
//
//  Created by hong on 2023/02/21.
//

import SwiftUI
import ComposableArchitecture

@main
struct CounterApp: App {
    var body: some Scene {

        let resultListStateTag = UUID()
        let resultListStateTagModal = UUID()

        let sample: IdentifiedArrayOf<CounterReducer.State> = [
            .init(id: .init(), secret: 10, count: 10),
            .init(),
        ]

        let testState = GameReducer.State(
          counter: .init(),
          timer: .init(),
          resultList: .init(results: sample),
          lastTimestamp: 100
//          resultListState: .init(.init(results: sample), id: resultListStateTag)
//          resultListStateModal: .init(.init(results: sample), id: resultListStateTagModal)
        )

        WindowGroup {
            NavigationView {
                GameView(store: .init(initialState: testState, reducer: GameReducer()._printChanges()))
            }
        }
    }
}
