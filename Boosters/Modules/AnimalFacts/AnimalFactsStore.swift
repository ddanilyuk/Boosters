//
//  AnimalFactsStore.swift
//  Boosters
//
//  Created by Denys Danyliuk on 15.07.2022.
//

import ComposableArchitecture
import IdentifiedCollections

struct AnimalFacts {

    // MARK: - State

    struct State: Equatable {
        var animal: Animal
        @BindableState var selectedFactId: Fact.ID

        // TODO: Loaded image caching
        var animalFacts: IdentifiedArrayOf<AnimalFact.State> {
            get {
                let facts = animal.content ?? []
                let array = facts
                    .enumerated()
                    .map {
                        AnimalFact.State(
                            fact: $1,
                            previousButtonVisible: $0 != 0,
                            nextButtonVisible: $0 != facts.count
                        )
                    }
                return IdentifiedArrayOf(uniqueElements: array)
            }
            set { }
        }

        init(animal: Animal) {
            self.animal = animal
            self.selectedFactId = animal.content?.first?.id ?? Fact.ID()
        }
    }

    // MARK: - Action

    enum Action: Equatable, BindableAction {
        case onAppear
        case animalFacts(id: AnimalFact.State.ID, action: AnimalFact.Action)
        case binding(BindingAction<State>)
    }

    // MARK: - Environment

    struct Environment { }

    // MARK: - Reducer

    static let reducer = Reducer<State, Action, Environment>.combine(
        AnimalFact.reducer
            .forEach(
                state: \State.animalFacts,
                action: /Action.animalFacts,
                environment: { _ in
                    AnimalFact.Environment()
                }
            ),
        coreReducer
    )

    static let coreReducer = Reducer<State, Action, Environment> { state, action, _ in
        switch action {
        case .onAppear:
            return .none

        case let .animalFacts(id, action: .previousButtonTapped):
            // TODO: improve logic
            if let index = state.animalFacts.index(id: id) {
                let newIndex = state.animalFacts.index(before: index)
                state.selectedFactId = state.animalFacts[newIndex].id
            }

            return .none

        case let .animalFacts(id, action: .nextButtonTapped):
            // TODO: improve logic
            if let index = state.animalFacts.index(id: id) {
                let newIndex = state.animalFacts.index(after: index)
                state.selectedFactId = state.animalFacts[newIndex].id
            }
            return .none

        case .binding:
            return .none
        }
    }
    .binding()

}
