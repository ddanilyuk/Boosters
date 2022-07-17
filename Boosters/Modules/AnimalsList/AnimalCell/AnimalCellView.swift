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
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)

                HStack(spacing: 0) {
                    KFImage.url(URL(string: viewStore.image))
                        .resizable()
                        .fade(duration: 0.25)
                        .placeholder { ProgressView().progressViewStyle(.circular) }
                        .scaledToFill()
                        .frame(width: 90)
                        .frame(minHeight: 90)
                        .clipped()
                        .cornerRadius(6)
                        .padding(6)

                    VStack(alignment: .leading, spacing: 6) {
                        Text(viewStore.title)
                            .font(.headline)

                        Text(viewStore.description)
                            .font(.callout)
                            .foregroundColor(.secondary)

                        Spacer()

                        statusView(viewStore.status)
                    }
                    .padding(6)

                    Spacer()
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .opacity(viewStore.status == .comingSoon ? 0.5 : 1)
            .onTapGesture { viewStore.send(.onTap) }
            .background(Color(.systemGroupedBackground))
        }
    }

    @ViewBuilder
    private func statusView(_ status: AnimalCell.State.Status) -> some View {
        switch status {
        case .free:
            Text("Free")
                .foregroundColor(.green)
                .font(.callout.bold())

        case .paid:
            HStack {
                Image(systemName: "lock")

                Text("Premium")

                Spacer()
            }
            .foregroundColor(.blue)
            .font(.callout.bold())

        case .comingSoon:
            Text("Coming soon...")
                .foregroundColor(.purple)
                .font(.callout.bold())
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
