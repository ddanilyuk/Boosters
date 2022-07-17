//
//  BoostersApp.swift
//  Boosters
//
//  Created by Denys Danyliuk on 15.07.2022.
//

import SwiftUI
import ComposableArchitecture

@main
struct BoostersApp: SwiftUI.App {

    static let store = Store<App.State, App.Action>(
        initialState: App.State(),
        reducer: App.reducer,
        environment: App.Environment.live
    )

    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            AppView(store: BoostersApp.store)
        }
    }

}
