//
//  AnimalFactStore.swift
//  Boosters
//
//  Created by Denys Danyliuk on 16.07.2022.
//

import ComposableArchitecture
import Kingfisher

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

    enum Action: Equatable, BindableAction {
        case previousButtonTapped
        case nextButtonTapped
        case shareImageButtonTapped
        case shareFactButtonTapped

        case delegate(Delegate)
        case binding(BindingAction<State>)

        enum Delegate: Equatable {
            case previousFact
            case nextFact
            case share(ActivityShareItem)
        }
    }

    // MARK: - Environment

    struct Environment { }

    // MARK: - Reducer

    static let reducer = Reducer<State, Action, Environment> { state, action, _ in
        switch action {
        case .previousButtonTapped:
            return Effect(value: .delegate(.previousFact))

        case .nextButtonTapped:
            return Effect(value: .delegate(.nextFact))

        case .shareImageButtonTapped:
            let key = state.fact.image + state.fact.fact
            // TODO: Use ImageCache from env
            guard let image = ImageCache.default.retrieveImageInMemoryCache(forKey: key) else {
                return .none
            }
            return Effect(value: .delegate(
                .share(ActivityShareItem(values: [image]))
            ))

        case .shareFactButtonTapped:
            return Effect(value: .delegate(
                .share(ActivityShareItem(values: [state.fact.fact]))
            ))

        case .delegate:
            return .none

        case .binding:
            return .none
        }
    }
    .binding()

}
