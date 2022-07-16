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
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
                .listStyle(.plain)
                .onAppear {
                    viewStore.send(.onAppear)
                }
                .redacted(reason: viewStore.isLoading && !viewStore.isLoaded ? .placeholder : [])
                .loadable(viewStore.binding(\.$isLoading))
                .alert(
                    store.scope(state: \.alert),
                    dismiss: .dismissAlert
                )
                .navigationLink(
                    unwrapping: viewStore.binding(\.$factScreen),
                    destination: { value in
                        AnimalFactsView(
                            store: Store(
                                initialState: value,
                                reducer: AnimalFacts.reducer,
                                environment: .init()
                            )
                        )
                    }
                )
                .navigationTitle("Animals")
                .navigationBarTitleDisplayMode(.inline)
                .background(Color(.systemGroupedBackground))
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
