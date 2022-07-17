//
//  AnimalsList.swift
//  Boosters
//
//  Created by Denys Danyliuk on 15.07.2022.
//

import ComposableArchitecture
import IdentifiedCollections

struct AnimalsList {

    // MARK: - State

    struct State: Equatable {
        var animals: IdentifiedArrayOf<Animal>
        var animalsCells: IdentifiedArrayOf<AnimalCell.State>

        var isLoaded = false
        @BindableState var isLoading = false

        @BindableState var selectedAnimalFacts: AnimalFacts.State?
        var alert: AlertState<Action>?

        var isRedacted: Bool {
            isLoading && !isLoaded
        }

        init() {
            let redactedAnimals = [Animal.redacted1, .redacted2]
            animals = IdentifiedArrayOf(uniqueElements: redactedAnimals)
            animalsCells = IdentifiedArrayOf(
                uniqueElements: redactedAnimals.map { AnimalCell.State(animal: $0) }
            )
        }
    }

    // MARK: - Action

    enum Action: Equatable, BindableAction {
        case onAppear

        case getAnimalsResponse(Result<[Animal], NetworkError>)
        case animalsCells(id: Animal.ID, action: AnimalCell.Action)
        case showAd(animal: Animal)
        case openDetails(animal: Animal)

        case selectedAnimalFacts(AnimalFacts.Action)

        case dismissAlert
        case binding(BindingAction<State>)
    }

    // MARK: - Environment

    struct Environment {
        let mainQueue: AnySchedulerOf<DispatchQueue>
        let animalsService: AnimalsService
        let kingfisherService: KingfisherService
    }

    // MARK: - Reducer

    static let reducer = Reducer<State, Action, Environment>.combine(
        AnimalFacts.reducer
            .optional()
            .pullback(
                state: \State.selectedAnimalFacts,
                action: /Action.selectedAnimalFacts,
                environment: {
                    AnimalFacts.Environment(kingfisherService: $0.kingfisherService)
                }
            ),
        coreReducer
    )

    static private let coreReducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .onAppear:
            guard !state.isLoaded else {
                return .none
            }
            state.isLoading = true
            return environment.animalsService
                .getAnimals()
                .receive(on: environment.mainQueue)
                .catchToEffect(Action.getAnimalsResponse)

        case let .getAnimalsResponse(.success(animals)):
            state.isLoading = false
            state.isLoaded = true
            state.animals = IdentifiedArrayOf(uniqueElements: animals.sorted())
            state.animalsCells = IdentifiedArrayOf(
                uniqueElements: state.animals.map { AnimalCell.State(animal: $0) }
            )
            return .none

        case let .getAnimalsResponse(.failure(networkError)):
            state.isLoading = false
            state.alert = AlertState(
                title: TextState("Oooops Error"),
                message: TextState(networkError.description),
                dismissButton: .default(TextState("Ok"))
            )
            return .none

        case let .animalsCells(id, .onTap):
            guard let animal = state.animals[id: id] else {
                return .none
            }
            switch animal.status {
            case .free:
                return Effect(value: .openDetails(animal: animal))

            case .paid:
                state.alert = AlertState(
                    title: TextState("Watch Ad to continue"),
                    primaryButton: .default(
                        TextState("Show Ad"),
                        action: .send(.showAd(animal: animal))
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
                .delay(for: 2, scheduler: environment.mainQueue)
                .eraseToEffect()

        case let .openDetails(animal):
            state.isLoading = false
            state.selectedAnimalFacts = AnimalFacts.State(animal: animal)
            return .none

        case .dismissAlert:
            state.alert = nil
            return .none

        case .animalsCells:
            return .none

        case .selectedAnimalFacts:
            return .none

        case .binding:
            return .none
        }
    }
    .binding()

}
