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
            GeometryReader { proxy in
                TabView(selection: viewStore.binding(\.$selectedFactId)) {
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
                    .frame(
                        width: proxy.size.width,
                        height: proxy.size.height
                    )
                }
                .animation(.default, value: viewStore.selectedFactId)
            }
            .background(Color(.systemGroupedBackground))
            .tabViewStyle(.page(indexDisplayMode: .never))
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(viewStore.animal.title)
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
                    environment: AnimalFacts.Environment()
                )
            )
        }
    }
}
