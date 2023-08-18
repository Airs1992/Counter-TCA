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

        let sample: IdentifiedArrayOf<GameReducer.GameResult> = [
            .init(counter: .init(id: .init(), secret: 10, count: 10)),
            .init(counter: .init()),
        ]

        let testState = GameReducer.State(
          counter: .init(),
          resultList: .init(results: sample),
          selectionResultList: .init(.init(results: sample), id: UUID(uuidString: "348D742D-15D0-4D51-BAB0-C24AAE5AA439") ?? UUID())
        )

        WindowGroup {
            NavigationView {
                GameView(store: .init(initialState: testState, reducer: GameReducer()._printChanges()))
            }
        }
    }
}
