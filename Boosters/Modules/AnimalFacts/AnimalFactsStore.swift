//
//  AnimalFactsStore.swift
//  Boosters
//
//  Created by Denys Danyliuk on 15.07.2022.
//

import ComposableArchitecture

struct AnimalFacts {

    // MARK: - State

    struct State: Equatable {
        var animal: Animal
    }

    // MARK: - Action

    enum Action: Equatable {
        case onAppear
    }

    // MARK: - Environment

    struct Environment { }

    // MARK: - Reducer

    static let reducer = Reducer<State, Action, Environment> { _, action, _ in
        switch action {
        case .onAppear:
            return .none
        }
    }

}
