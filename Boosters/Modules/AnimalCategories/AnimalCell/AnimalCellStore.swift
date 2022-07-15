//
//  AnimalCellStore.swift
//  Boosters
//
//  Created by Denys Danyliuk on 15.07.2022.
//

import ComposableArchitecture
import CoreGraphics

struct AnimalCell {

    // MARK: - State

    struct State: Equatable, Identifiable {
        let animal: Animal

        var id: Animal.ID {
            return animal.id
        }
    }

    // MARK: - Action

    enum Action: Equatable {
        case onTap
    }

    // MARK: - Environment

    struct Environment { }

    // MARK: - Reducer

    static let reducer = Reducer<State, Action, Environment> { _, action, _ in
        switch action {
        case .onTap:
            return .none
        }
    }

}
