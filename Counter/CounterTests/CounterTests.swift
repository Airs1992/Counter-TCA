//
//  CounterTests.swift
//  CounterTests
//
//  Created by hong on 2023/02/21.
//

import ComposableArchitecture
import XCTest

@testable import Counter

@MainActor
final class CounterTests: XCTestCase {

    func testSetCount() async throws {
        let store = TestStore(
            initialState: CounterReducer.State(),
            reducer: CounterReducer()
        )
//        store.dependencies.generateRandom.generateRandomInt = { _ in 4 }

        await store.send(.playNext) { state in
            state.count = 0
            state.secret = 4
        }
    }
}
