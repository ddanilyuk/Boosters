//
//  AppStore.swift
//  Boosters
//
//  Created by Denys Danyliuk on 15.07.2022.
//

import ComposableArchitecture

struct App {

    // MARK: - State

    struct State: Equatable {
        var appDelegate: AppDelegate.State = AppDelegate.State()
        var animalCategories: AnimalCategories.State?

        mutating func set(_ currentState: CurrentState) {
            switch currentState {
            case .animalCategories:
                self.animalCategories = AnimalCategories.State()
            }
        }

        enum CurrentState {
            case animalCategories
        }
    }

    // MARK: - Action

    enum Action: Equatable {
        case appDelegate(AppDelegate.Action)
        case animalCategories(AnimalCategories.Action)
    }

    // MARK: - Environment

    struct Environment {
        let networkService: NetworkService
        let animalsService: AnimalsService

        static var live: Self {
            let baseURL = URL(string: "https://drive.google.com")!
            let networkService: NetworkService = .live(baseURL: baseURL)
            let animalsService: AnimalsService = .live(networkService: networkService)

            return Self(
                networkService: networkService,
                animalsService: animalsService
            )
        }
    }

    // MARK: - Reducer

    static var reducerCore = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .appDelegate(.didFinishLaunching):
            state.set(.animalCategories)
            return .none

        case .appDelegate:
            return .none

        case .animalCategories:
            return .none
        }
    }

    static var reducer = Reducer<State, Action, Environment>.combine(
        AppDelegate.reducer
            .pullback(
                state: \State.appDelegate,
                action: /Action.appDelegate,
                environment: { $0.appDelegate }
            ),
        AnimalCategories.reducer
            .optional()
            .pullback(
                state: \State.animalCategories,
                action: /Action.animalCategories,
                environment: { $0.animalCategories }
            ),
        reducerCore
    )

}

// MARK: App.Environment + Extensions

extension App.Environment {

    var appDelegate: AppDelegate.Environment {
        AppDelegate.Environment()
    }

    var animalCategories: AnimalCategories.Environment {
        AnimalCategories.Environment(
            animalsService: animalsService
        )
    }

}
