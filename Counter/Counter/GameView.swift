//
//  GameView.swift
//  Counter
//
//  Created by hong on 2023/02/26.
//

import SwiftUI
import ComposableArchitecture

struct GameView: View {
    let resultListStateTag = UUID()
    let store: StoreOf<GameReducer>
    var body: some View {
        VStack {
            // GameのstateはViewをドライブする必要がない、statelessを設定する
            WithViewStore(store.scope(state: \.resultList.results)) { viewStore in
                VStack {
                    resultLabel(viewStore.state.elements)
                }.onAppear {
                    viewStore.send(.timer(.start))
                }
            }
            TimerView(store: store.scope(state: \.timer, action: GameReducer.Action.timer))
            CounterView(store: store.scope(state: \.counter, action: GameReducer.Action.counter))
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
//                NavigationLink("Detail") {
//                    GameResultListView(store: store.scope(state: \.resultList, action: GameReducer.Action.resultList))
//                }
                
                WithViewStore(store) { viewStore in
                    NavigationLink("Detail", tag: resultListStateTag, selection: viewStore.binding(get: \.resultListState?.id, send: GameReducer.Action.setNavigation), destination: {
                        IfLetStore(store.scope(state: \.resultListState?.value,
                                              action: GameReducer.Action.resultList),
                                                then: { GameResultListView(store: $0) })
                    })
                }
            }
        }
    }

    func resultLabel(_ results: [GameReducer.GameResult]) -> some View {
      Text("Result: \(results.filter(\.correct).count)/\(results.count) correct")
    }
}
