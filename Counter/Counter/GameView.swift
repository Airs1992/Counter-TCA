//
//  GameView.swift
//  Counter
//
//  Created by hong on 2023/08/04.
//

import ComposableArchitecture
import SwiftUI

struct GameView: View {
    let store: StoreOf<GameReducer>
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                Text("ゲーム回数：" + String(viewStore.results.count))
                CounterView(store: store.scope(state: \.counter, action: GameReducer.Action.counter))
            }
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(store: .init(initialState: .init(), reducer: GameReducer()))
    }
}
