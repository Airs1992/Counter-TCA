//
//  GenerateRandom.swift
//  Counter
//
//  Created by hong on 2023/02/25.
//

import ComposableArchitecture
import Foundation
import XCTestDynamicOverlay

struct GenerateRandom {
    var generateRandomInt: (ClosedRange<Int>) -> Int
}

extension GenerateRandom: DependencyKey {
    static var liveValue: GenerateRandom {
        return .init(generateRandomInt: { Int.random(in: $0) })
    }
    static let testValue = Self(
        generateRandomInt: unimplemented("\(Self.self).generateRandomInt")
    )
}

extension DependencyValues {
    var generateRandom: GenerateRandom {
        get { self[GenerateRandom.self] }
        set { self[GenerateRandom.self] = newValue }
    }
}
