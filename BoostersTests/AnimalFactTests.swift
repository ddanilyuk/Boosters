//
//  AnimalFactTests.swift
//  BoostersTests
//
//  Created by Denys Danyliuk on 17.07.2022.
//

import ComposableArchitecture
import XCTest
@testable import Boosters

class AnimalFactTests: XCTestCase {

    func testPreviousButtonTapped() throws {

        let fact = Fact(
            fact: "All cats are pretty",
            image: "https://cataas.com/cat"
        )

        let store = TestStore(
            initialState: AnimalFact.State(
                fact: fact,
                previousButtonVisible: true,
                nextButtonVisible: true
            ),
            reducer: AnimalFact.reducer,
            environment: AnimalFact.Environment(
                kingfisherService: .mock
            )
        )

        store.send(.previousButtonTapped)
        store.receive(.delegate(.previousFact))
    }

    func testNextButtonTapped() throws {

        let fact = Fact(
            fact: "All cats are pretty",
            image: "https://cataas.com/cat"
        )

        let store = TestStore(
            initialState: AnimalFact.State(
                fact: fact,
                previousButtonVisible: true,
                nextButtonVisible: true
            ),
            reducer: AnimalFact.reducer,
            environment: AnimalFact.Environment(
                kingfisherService: .mock
            )
        )

        store.send(.nextButtonTapped)
        store.receive(.delegate(.nextFact))
    }

}
