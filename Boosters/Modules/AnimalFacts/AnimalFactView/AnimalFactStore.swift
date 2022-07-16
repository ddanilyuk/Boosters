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

        let id: String
        let imageURL: URL?
        let imageCacheKey: String
        let text: String
        let previousButtonVisible: Bool
        let nextButtonVisible: Bool

        init(
            fact: Fact,
            previousButtonVisible: Bool,
            nextButtonVisible: Bool
        ) {
            id = fact.id
            imageURL = fact.imageURL
            imageCacheKey = fact.imageCacheKey
            text = fact.fact
            self.previousButtonVisible = previousButtonVisible
            self.nextButtonVisible = nextButtonVisible
        }

    }

    // MARK: - Action

    enum Action: Equatable, BindableAction {
        case previousButtonTapped
        case nextButtonTapped
        case shareImageButtonTapped
        case shareTextButtonTapped

        case delegate(Delegate)
        case binding(BindingAction<State>)

        enum Delegate: Equatable {
            case previousFact
            case nextFact
            case share(ActivityShareItem)
        }
    }

    // MARK: - Environment

    struct Environment {
        let kingfisherService: KingfisherService
    }

    // MARK: - Reducer

    static let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .previousButtonTapped:
            return Effect(value: .delegate(.previousFact))

        case .nextButtonTapped:
            return Effect(value: .delegate(.nextFact))

        case .shareImageButtonTapped:
            let imageCache = environment.kingfisherService.imageCache
            guard let image = imageCache.retrieveImageInMemoryCache(forKey: state.imageCacheKey) else {
                return .none
            }
            let shareItem = ActivityShareItem(values: [image])

            return Effect(value: .delegate(.share(shareItem)))

        case .shareTextButtonTapped:
            let shareItem = ActivityShareItem(values: [state.text])
            return Effect(value: .delegate(.share(shareItem)))

        case .delegate:
            return .none

        case .binding:
            return .none
        }
    }
    .binding()

}
