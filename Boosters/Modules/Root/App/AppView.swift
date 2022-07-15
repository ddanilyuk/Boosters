//
//  AppView.swift
//  Boosters
//
//  Created by Denys Danyliuk on 15.07.2022.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {

    let store: Store<App.State, App.Action>

    var body: some View {
        Group {
            IfLetStore(
                store.scope(state: \App.State.animalCategories, action: App.Action.animalCategories),
                then: AnimalCategoriesView.init
            )
        }
    }

}
