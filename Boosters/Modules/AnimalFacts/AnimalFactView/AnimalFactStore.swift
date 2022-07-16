//
//  AnimalFactStore.swift
//  Boosters
//
//  Created by Denys Danyliuk on 16.07.2022.
//

import ComposableArchitecture

struct AnimalFact {

    // MARK: - State

    struct State: Equatable, Identifiable {
        let fact: Fact
        var previousButtonVisible: Bool = false
        var nextButtonVisible: Bool = true

        var id: Fact.ID {
            fact.id
        }
    }

    // MARK: - Action

    enum Action: Equatable {
        case previousButtonTapped
        case nextButtonTapped
    }

    // MARK: - Environment

    struct Environment { }

    // MARK: - Reducer

    static let reducer = Reducer<State, Action, Environment> { _, action, _ in
        switch action {
        case .previousButtonTapped:
            return .none

        case .nextButtonTapped:
            return .none
        }
    }

}
