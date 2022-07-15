//
//  AnimalFactsView.swift
//  Boosters
//
//  Created by Denys Danyliuk on 15.07.2022.
//

import SwiftUI
import ComposableArchitecture

struct AnimalFactsView: View {

    let store: Store<AnimalFacts.State, AnimalFacts.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            Text(viewStore.animal.title)
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
