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
        var animalsList: AnimalsList.State?

        mutating func set(_ currentState: CurrentState) {
            switch currentState {
            case .animalsList:
                self.animalsList = AnimalsList.State()
            }
        }

        enum CurrentState {
            case animalsList
        }
    }

    // MARK: - Action

    enum Action: Equatable {
        case appDelegate(AppDelegate.Action)
        case animalsList(AnimalsList.Action)
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
            state.set(.animalsList)
            return .none

        case .appDelegate:
            return .none

        case .animalsList:
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
        AnimalsList.reducer
            .optional()
            .pullback(
                state: \State.animalsList,
                action: /Action.animalsList,
                environment: { $0.animalsList }
            ),
        reducerCore
    )

}

// MARK: App.Environment + Extensions

extension App.Environment {

    var appDelegate: AppDelegate.Environment {
        AppDelegate.Environment()
    }

    var animalsList: AnimalsList.Environment {
        AnimalsList.Environment(
            animalsService: animalsService
        )
    }

}
