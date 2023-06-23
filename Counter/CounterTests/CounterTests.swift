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

    func testSetCount() {
        let store = TestStore(
            initialState: CounterReducer.State(),
            reducer: CounterReducer()
        )

        store.send(.setCount("1")) { state in
            state.count = 1
        }
    }

    func testDecrement() {
        let store = TestStore(
            initialState: CounterReducer.State(count: 10),
            reducer: CounterReducer()
        )

        store.send(.decrement) { state in
            state.count = 9
        }
    }

    func testIncrement() {
        let store = TestStore(
            initialState: CounterReducer.State(count: 99),
            reducer: CounterReducer()
        )

        store.send(.increment) { state in
            state.count = 100
        }
    }

    func testReset() {
        let store = TestStore(
            initialState: CounterReducer.State(count: 66),
            reducer: CounterReducer()
        )

        store.send(.reset) { state in
            state.count = 0
        }
    }

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
