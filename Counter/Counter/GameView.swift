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
            TimerView(store: store.scope(state: \.timer, action: GameReducer.Action.timer))
            CounterView(store: store.scope(state: \.counter, action: GameReducer.Action.counter))
            // GameのstateはViewをドライブする必要がない、statelessを設定する
            WithViewStore(store.stateless) { viewStore in
                Color.clear
                    .frame(width: 0, height: 0)
                    .onAppear { viewStore.send(.timer(.start)) }
            }
        }
    }
}
