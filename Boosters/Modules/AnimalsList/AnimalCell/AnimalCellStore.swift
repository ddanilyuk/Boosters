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

        enum Status: Equatable {
            case paid
            case free
            case comingSoon
        }

        let id: String
        let image: String
        let title: String
        let description: String
        let status: Status

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

extension AnimalCell.State {

    init(animal: Animal) {
        id = animal.id
        image = animal.image
        title = animal.title
        description = animal.description
        status = Status(animalStatus: animal.status)
    }

}

extension AnimalCell.State.Status {

    init(animalStatus: Animal.Status) {
        switch animalStatus {
        case .paid:
            self = .paid

        case .free:
            self = .free

        case .comingSoon:
            self = .comingSoon
        }
    }

}
