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
    func testCounterIncrement() async throws {

        let store = TestStore(
            initialState: CounterReducer.State(),
            reducer: CounterReducer()
        )

        await store.send(.increment) { state in
            state.count += 1
        }

        await store.receive(.changeCountColor(1)) { state in
            state.count = 1
            state.colorHex = 0x00FF00
        }

        await store.send(.decrement) { state in
            state.count -= 1
        }

        await store.receive(.changeCountColor(0)) { state in
            state.count = 0
            state.colorHex = 0x000000
        }

        await store.send(.decrement) { state in
            state.count -= 1
        }

        await store.receive(.changeCountColor(-1)) { state in
            state.count = -1
            state.colorHex = 0xFF0000
        }

        await store.send(.reset) { state in
            state.count = 0
            state.colorHex = 0x000000
        }
    }

    func testSetCount() throws {
        let store = TestStore(
            initialState: CounterReducer.State(),
            reducer: CounterReducer()
        )

        store.send(.setCount("1")) { state in
            state.count = 1
        }
    }
}
