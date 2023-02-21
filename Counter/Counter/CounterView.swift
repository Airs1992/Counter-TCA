//
//  CounterView.swift
//  Counter
//
//  Created by hong on 2023/02/21.
//

import SwiftUI
import ComposableArchitecture

public struct CounterView: View {
    public let store: StoreOf<CounterReducer>
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            HStack {
              // 1
              Button("-") { viewStore.send(.decrement) }
              Text("\(viewStore.count)")
              Button("+") { viewStore.send(.increment) }
            }
        }
    }
}



struct CounterView_Previews: PreviewProvider {
    static var previews: some View {
        CounterView(store: .init(initialState: .init(), reducer: CounterReducer()))
    }
}
