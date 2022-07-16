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
        let title: String
        var facts: IdentifiedArrayOf<Fact>
        var animalFacts: IdentifiedArrayOf<AnimalFact.State>

        @BindableState var selectedFactID: Fact.ID
        @BindableState var activityShareItem: ActivityShareItem?

        init(animal: Animal) {
            let animalContent = animal.content ?? []
            title = animal.title
            facts = IdentifiedArrayOf(uniqueElements: animalContent)
            selectedFactID = animal.content?.first?.id ?? Fact.ID()
            animalFacts = IdentifiedArrayOf(
                uniqueElements: animalContent
                    .enumerated()
                    .map {
                        AnimalFact.State(
                            fact: $1,
                            previousButtonVisible: $0 != 0,
                            nextButtonVisible: $0 != animalContent.count - 1
                        )
                    }
            )
        }
    }

    // MARK: - Action

    enum Action: Equatable, BindableAction {
        case onAppear
        case animalFacts(id: AnimalFact.State.ID, action: AnimalFact.Action)
        case binding(BindingAction<State>)
    }

    // MARK: - Environment

    struct Environment {
        let kingfisherService: KingfisherService
    }

    // MARK: - Reducer

    static let reducer = Reducer<State, Action, Environment>.combine(
        AnimalFact.reducer
            .forEach(
                state: \State.animalFacts,
                action: /Action.animalFacts,
                environment: {
                    AnimalFact.Environment(
                        kingfisherService: $0.kingfisherService
                    )
                }
            ),
        coreReducer
    )

    static private let coreReducer = Reducer<State, Action, Environment> { state, action, _ in
        switch action {
        case .onAppear:
            return .none

        case let .animalFacts(id, action: .delegate(.previousFact)):
            guard let currentIndex = state.animalFacts.index(id: id) else {
                return .none
            }
            let newIndex = state.animalFacts.index(before: currentIndex)
            state.selectedFactID = state.animalFacts[newIndex].id
            return .none

        case let .animalFacts(id, action: .delegate(.nextFact)):
            guard let currentIndex = state.animalFacts.index(id: id) else {
                return .none
            }
            let newIndex = state.animalFacts.index(after: currentIndex)
            state.selectedFactID = state.animalFacts[newIndex].id
            return .none

        case let .animalFacts(id, action: .delegate(.share(activityShareItem))):
            state.activityShareItem = activityShareItem
            return .none

        case .animalFacts:
            return .none

        case .binding:
            return .none
        }
    }
    .binding()

}
