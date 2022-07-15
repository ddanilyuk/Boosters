//
//  AnimalCategoriesStore.swift
//  Boosters
//
//  Created by Denys Danyliuk on 15.07.2022.
//

import ComposableArchitecture
import IdentifiedCollections

struct AnimalCategories {

    // MARK: - State

    struct State: Equatable {
        var animals: [Animal] = []
        var cells: IdentifiedArrayOf<AnimalCell.State> = []
    }

    // MARK: - Action

    enum Action: Equatable {
        case onAppear

        case getAnimalsResponse(Result<[Animal], NetworkError>)

        case cells(id: Animal.ID, action: AnimalCell.Action)
    }

    // MARK: - Environment

    struct Environment {
        let animalsService: AnimalsService
    }

    // MARK: - Reducer

    static let reducer = Reducer<State, Action, Environment>.combine(
        reducerCore
    )

    static let reducerCore = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .onAppear:
            return environment.animalsService
                .getAnimals()
                .receive(on: DispatchQueue.main)
                .catchToEffect(Action.getAnimalsResponse)

        case let .getAnimalsResponse(.success(animals)):
            state.animals = animals
            state.cells = IdentifiedArrayOf(uniqueElements: animals.map { AnimalCell.State(animal: $0) })
            return .none

        case let .getAnimalsResponse(.failure(networkError)):
            print(networkError)
            return .none

        case .cells:
            return .none
        }
    }

}
