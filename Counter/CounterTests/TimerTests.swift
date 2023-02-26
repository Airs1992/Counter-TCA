//
//  TimerTests.swift
//  CounterTests
//
//  Created by hong on 2023/02/26.
//

import XCTest
import ComposableArchitecture
@testable import Counter

class TimerTests: XCTestCase {
    let scheduler = DispatchQueue.test

    func testTimerUpdate() throws {
        let store = TestStore(
            initialState: TimerReducer.State(),
            reducer: TimerReducer()
        ) {
            $0.date = .constant(Date(timeIntervalSince1970: 100))
            $0.mainQueue = scheduler.eraseToAnyScheduler()
        }

        store.send(.start) {
            $0.started = Date(timeIntervalSince1970: 100)
        }

        // 1 scheduler 35 milliseconds経過する
        scheduler.advance(by: .milliseconds(35))
        // 2 三つのtimeUpdated取れるはず
        store.receive(.timeUpdated) {
            $0.duration = 0.01
        }
        store.receive(.timeUpdated) {
            $0.duration = 0.02
        }
        store.receive(.timeUpdated) {
            $0.duration = 0.03
        }
        // 3 停止する
        store.send(.stop)
    }
}
