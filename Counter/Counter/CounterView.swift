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
                checkLabel(with: viewStore.checkResult)
                HStack {
                    Button("-") { viewStore.send(.decrement) }
                    TextField(
                        String(viewStore.count),
                        text: viewStore.binding(get: \.countString, send: CounterReducer.Action.setCount)
                    )
                    .frame(width: 40)
                    .multilineTextAlignment(.center)
                    Button("+") { viewStore.send(.increment) }
                }
                Button("Reset") { viewStore.send(.reset) }
                Button("Next") { viewStore.send(.playNext) }
            }
            .padding(20)
        }
    }

    func checkLabel(with checkResult: CounterReducer.State.CheckResult) -> some View {
        switch checkResult {
        case .lower:
          return Label("Lower", systemImage: "lessthan.circle")
            .foregroundColor(.red)
        case .higher:
          return Label("Higher", systemImage: "greaterthan.circle")
            .foregroundColor(.red)
        case .equal:
          return Label("Correct", systemImage: "checkmark.circle")
            .foregroundColor(.green)
        }
    }
}



struct CounterView_Previews: PreviewProvider {
    static var previews: some View {
        CounterView(store: .init(initialState: .init(), reducer: CounterReducer()))
    }
}
