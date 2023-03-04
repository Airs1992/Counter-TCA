//
//  GameResultListView.swift
//  Counter
//
//  Created by hong on 2023/02/27.
//

import SwiftUI
import ComposableArchitecture

struct GameResultListView: View {
    let store: StoreOf<GameResultListReducer>
    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                ForEachStore(
                  self.store.scope(state: \.results, action: GameResultListReducer.Action.row(id:action:))
                ) { rowStore in
                    WithViewStore(rowStore, observe: { $0 }) { rowViewStore in
                        NavigationLink(
                          destination: CounterView(store: rowStore),
                          tag: rowViewStore.id,
                          selection: viewStore.binding(
                            get: \.selection?.id,
                            send: GameResultListReducer.Action.setNavigation(selection:)
                          )
                        ) {
                            HStack {
                                Image(systemName: rowViewStore.state.correct ? "checkmark.circle" : "x.circle")
                                Text("Secret: \(rowViewStore.state.secret)")
                                Text("Answer: \(rowViewStore.state.count)")
                            }
                            .foregroundColor(rowViewStore.state.correct ? .green : .red)
                        }


                    }
                }
                .onDelete { viewStore.send(.remove(offset: $0)) }
            }
            .toolbar {
                EditButton()
            }
        }
    }
}

struct GameResultListView_Previews: PreviewProvider {
    static var previews: some View {
        GameResultListView(
            store: .init(
                initialState: .init(results: [
                    CounterReducer.State(id: .init(), secret: 20, count: 20),
                    CounterReducer.State()
                ]),
                reducer: GameResultListReducer()
            )
        )
    }
}
