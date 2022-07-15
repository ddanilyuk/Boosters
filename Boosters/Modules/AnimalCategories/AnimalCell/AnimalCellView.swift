//
//  AnimalCellView.swift
//  Boosters
//
//  Created by Denys Danyliuk on 15.07.2022.
//

import SwiftUI
import ComposableArchitecture

struct AnimalCellView: View {

    let store: Store<AnimalCell.State, AnimalCell.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            Text(viewStore.animal.title)
        }
    }

}

// MARK: - Preview

struct AnimalCellView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AnimalCellView(
                store: Store(
                    initialState: AnimalCell.State(animal: Animal.mock),
                    reducer: AnimalCell.reducer,
                    environment: AnimalCell.Environment()
                )
            )
        }
    }
}
