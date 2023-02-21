//
//  CounterApp.swift
//  Counter
//
//  Created by hong on 2023/02/21.
//

import SwiftUI

@main
struct CounterApp: App {
    var body: some Scene {
        WindowGroup {
            CounterView(store: .init(initialState: .init(), reducer: CounterReducer()._printChanges()))
        }
    }
}
