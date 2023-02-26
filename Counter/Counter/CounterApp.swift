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
            GameView(store: .init(initialState: .init(), reducer: GameReducer()._printChanges()))
        }
    }
}
