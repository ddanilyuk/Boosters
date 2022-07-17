//
//  AnimalFactsView.swift
//  Boosters
//
//  Created by Denys Danyliuk on 15.07.2022.
//

import SwiftUI
import ComposableArchitecture
import Kingfisher

struct AnimalFactsView: View {

    let store: Store<AnimalFacts.State, AnimalFacts.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            TabView(selection: viewStore.binding(\.$selectedFactID)) {
                ForEachStore(
                    store.scope(
                        state: \AnimalFacts.State.animalFacts,
                        action: AnimalFacts.Action.animalFacts
                    ),
                    content: { store in
                        AnimalFactView(store: store)
                            .tag(ViewStore(store).id)
                    }
                )
            }
            .animation(.default, value: viewStore.selectedFactID)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .sheet(
                item: viewStore.binding(\.$activityShareItem),
                content: ActivityView.init(activityShareItem:)
            )
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(viewStore.title)
            .background(Color(.systemGroupedBackground))
        }
    }

}

// MARK: - Preview

struct AnimalFactsView_Previews: PreviewProvider {

    static var previews: some View {
        NavigationView {
            AnimalFactsView(
                store: Store(
                    initialState: AnimalFacts.State(animal: .mock),
                    reducer: AnimalFacts.reducer,
                    environment: AnimalFacts.Environment(
                        kingfisherService: .mock
                    )
                )
            )
        }
    }
    
}
