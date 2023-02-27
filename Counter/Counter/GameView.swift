//
//  GameView.swift
//  Counter
//
//  Created by hong on 2023/02/26.
//

import SwiftUI
import ComposableArchitecture

struct GameView: View {
    let store: StoreOf<GameReducer>
    var body: some View {
        VStack {
            // GameのstateはViewをドライブする必要がない、statelessを設定する
            WithViewStore(store.scope(state: \.results)) { viewStore in
                VStack {
                    resultLabel(viewStore.state.elements)
                }.onAppear {
                    viewStore.send(.timer(.start))
                }
            }
            TimerView(store: store.scope(state: \.timer, action: GameReducer.Action.timer))
            CounterView(store: store.scope(state: \.counter, action: GameReducer.Action.counter))
        }
    }

    func resultLabel(_ results: [GameReducer.GameResult]) -> some View {
      Text("Result: \(results.filter(\.correct).count)/\(results.count) correct")
    }
}
