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
    func testCounterIncrement() throws {
        let store = TestStore(
            initialState: CounterReducer.State(count: Int.random(in: -100...100)),
            reducer: CounterReducer()
        )
        store.send(.increment) { state in
            state.count += 1
        }
    }
}
