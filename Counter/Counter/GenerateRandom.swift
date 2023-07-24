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

extension GenerateRandom: TestDependencyKey {
    static let previewValue = Self { _ in
        return 14
    }

    static let testValue = Self(
        generateRandomInt: unimplemented("\(Self.self).generateRandomInt")
    )
}

extension GenerateRandom: DependencyKey {
    static var liveValue: GenerateRandom {
        return .init(generateRandomInt: { Int.random(in: $0) })
    }
}

extension DependencyValues {
    var generateRandom: GenerateRandom {
        get { self[GenerateRandom.self] }
        set { self[GenerateRandom.self] = newValue }
    }
}
