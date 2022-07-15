//
//  AnimalCategoriesView.swift
//  Boosters
//
//  Created by Denys Danyliuk on 15.07.2022.
//

import SwiftUI
import ComposableArchitecture

struct AnimalCategoriesView: View {

    let store: Store<AnimalCategories.State, AnimalCategories.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                List {
                    ForEachStore(
                        store.scope(state: \.cells, action: AnimalCategories.Action.cells),
                        content: AnimalCellView.init(store:)
                    )
                }
                .onAppear {
                    viewStore.send(.onAppear)
                }
                .navigationTitle("Animals")
            }
        }
    }

}

// MARK: - Preview

struct AnimalCategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AnimalCategoriesView(
                store: Store(
                    initialState: AnimalCategories.State(),
                    reducer: AnimalCategories.reducer,
                    environment: AnimalCategories.Environment(
                        animalsService: .mock
                    )
                )
            )
        }
    }
}
