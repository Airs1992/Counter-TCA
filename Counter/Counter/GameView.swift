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
        // GameのstateはViewをドライブする必要がない、statelessを設定する
        WithViewStore(store.stateless) { viewStore in
            VStack {
                TimerView(store: store.scope(state: \.timer, action: GameReducer.Action.timer))
                CounterView(store: store.scope(state: \.counter, action: GameReducer.Action.counter))
            }.onAppear {
                viewStore.send(.timer(.start))
            }
        }
    }
}
