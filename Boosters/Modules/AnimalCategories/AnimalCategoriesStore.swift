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
        var animals: [Animal] = [.mock]
        var cells: IdentifiedArrayOf<AnimalCell.State> = [.init(animal: .mock)]
        var isLoaded = false

        @BindableState var factScreen: AnimalFacts.State?
        @BindableState var isLoading = false
        var alert: AlertState<Action>?
    }

    // MARK: - Action

    enum Action: Equatable, BindableAction {
        case onAppear
        case getAnimalsResponse(Result<[Animal], NetworkError>)
        case cells(id: Animal.ID, action: AnimalCell.Action)
        case showAd(animal: Animal)
        case openDetails(animal: Animal)

        case dismissAlert
        case binding(BindingAction<State>)
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
            guard !state.isLoaded else {
                return .none
            }
            state.isLoading = true
            return environment.animalsService
                .getAnimals()
                .receive(on: DispatchQueue.main)
                .catchToEffect(Action.getAnimalsResponse)

        case let .getAnimalsResponse(.success(animals)):
            state.isLoading = false
            state.isLoaded = true
            state.animals = animals
            state.cells = IdentifiedArrayOf(uniqueElements: animals.map { AnimalCell.State(animal: $0) })
            return .none

        case let .getAnimalsResponse(.failure(networkError)):
            state.isLoading = false
            state.alert = AlertState(
                title: TextState("Oooops Error"),
                message: TextState(networkError.description),
                dismissButton: .default(TextState("Ok"))
            )
            return .none

        case let .cells(id, .onTap):
            guard let item = state.cells[id: id] else {
                return .none
            }
            switch item.animal.status {
            case .free:
                return Effect(value: .openDetails(animal: item.animal))

            case .paid:
                state.alert = AlertState(
                    title: TextState("Watch Ad to continue"),
                    primaryButton: .default(
                        TextState("Show Ad"),
                        action: .send(.showAd(animal: item.animal))
                    ),
                    secondaryButton: .cancel(TextState("Cancel"))
                )
                return .none

            case .comingSoon:
                state.alert = AlertState(
                    title: TextState("Coming soon"),
                    dismissButton: .default(TextState("Ok"))
                )
                return .none
            }

        case let .showAd(animal):
            state.isLoading = true
            return Effect(value: .openDetails(animal: animal))
                .delay(for: 2, scheduler: DispatchQueue.main)
                .eraseToEffect()

        case let .openDetails(animal):
            state.isLoading = false
            state.factScreen = .init(animal: animal)
            return .none

        case .dismissAlert:
            state.alert = nil
            return .none

        case .cells:
            return .none

        case .binding:
            return .none
        }
    }
    .binding()

}
