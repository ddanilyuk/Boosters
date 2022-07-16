//
//  AnimalsListView.swift
//  Boosters
//
//  Created by Denys Danyliuk on 15.07.2022.
//

import SwiftUI
import ComposableArchitecture

struct AnimalsListView: View {

    let store: Store<AnimalsList.State, AnimalsList.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                List {
                    ForEachStore(
                        store.scope(
                            state: \AnimalsList.State.animalsCells,
                            action: AnimalsList.Action.animalsCells
                        ),
                        content: AnimalCellView.init(store:)
                    )
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
                .listStyle(.plain)
                .onAppear { viewStore.send(.onAppear) }
                .redacted(reason: viewStore.isRedacted ? .placeholder : [])
                .loadable(viewStore.binding(\.$isLoading))
                .alert(
                    store.scope(state: \.alert),
                    dismiss: .dismissAlert
                )
                .navigationLink(
                    unwrapping: viewStore.binding(\.$selectedAnimalFacts),
                    destination: { value in
                        AnimalFactsView(
                            store: store.scope(
                                state: { _ in value },
                                action: AnimalsList.Action.selectedAnimalFacts
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
            AnimalsListView(
                store: Store(
                    initialState: AnimalsList.State(),
                    reducer: AnimalsList.reducer,
                    environment: AnimalsList.Environment(
                        animalsService: .mock,
                        kingfisherService: .mock
                    )
                )
            )
        }
    }

}
