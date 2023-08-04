//
//  GameResultListView.swift
//  Counter
//
//  Created by hong on 2023/08/04.
//

import ComposableArchitecture
import SwiftUI

struct GameResultListView: View {
    let store: StoreOf<GameResultListReducer>
    var body: some View {
        WithViewStore(store) { viewStore in
            List {
                ForEach(viewStore.state.results) { result in
                    HStack {
                        Image(systemName: result.correct ? "checkmark.circle" : "x.circle")
                        Text("Secret: \(result.counter.secret)")
                        Text("Answer: \(result.counter.count)")
                    }.foregroundColor(result.correct ? .green : .red)
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
                GameReducer.GameResult(counter: .init(id: .init(), secret: 20, count: 20)),
                GameReducer.GameResult(counter: .init())
            ]),
        reducer: GameResultListReducer()))
    }
}
