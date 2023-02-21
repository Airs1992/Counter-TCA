//
//  CounterView.swift
//  Counter
//
//  Created by hong on 2023/02/21.
//

import SwiftUI
import ComposableArchitecture

extension Color {
    public init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

public struct CounterView: View {
    public let store: StoreOf<CounterReducer>
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                HStack {
                    // 1
                    Button("-") { viewStore.send(.decrement) }
                    Text("\(viewStore.count)")
                        .foregroundColor(Color.init(hex: UInt(viewStore.state.colorHex)))
                    Button("+") { viewStore.send(.increment) }
                }
                Button("reset") { viewStore.send(.reset) }
            }

        }
    }
}



struct CounterView_Previews: PreviewProvider {
    static var previews: some View {
        CounterView(store: .init(initialState: .init(), reducer: CounterReducer()))
    }
}
