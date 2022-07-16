//
//  AnimalCellView.swift
//  Boosters
//
//  Created by Denys Danyliuk on 15.07.2022.
//

import SwiftUI
import ComposableArchitecture
import Kingfisher

struct AnimalCellView: View {

    let store: Store<AnimalCell.State, AnimalCell.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            HStack(spacing: 16) {
                KFImage.url(URL(string: viewStore.animal.image))
                    .resizable()
                    .fade(duration: 0.25)
                    .placeholder { _ in
                        ProgressView()
                            .progressViewStyle(.circular)
                    }
                    .scaledToFill()
                    .frame(width: 90, height: 90)
                    .clipped()

                VStack(alignment: .leading) {
                    Text(viewStore.animal.title)
                        .font(.headline)

                    Text(viewStore.animal.description)
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
            }
            .opacity(viewStore.animal.status == .comingSoon ? 0.5 : 1)
            .onTapGesture {
                viewStore.send(.onTap)
            }
        }
    }

}

// MARK: - Preview

struct AnimalCellView_Previews: PreviewProvider {
    static var previews: some View {
        AnimalCellView(
            store: Store(
                initialState: AnimalCell.State(animal: Animal.mock),
                reducer: AnimalCell.reducer,
                environment: AnimalCell.Environment()
            )
        )
        .previewLayout(.sizeThatFits)
        .fixedSize(horizontal: false, vertical: true)
        .frame(width: 385)
    }
}
