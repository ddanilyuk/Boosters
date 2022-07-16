//
//  AnimalFactView.swift
//  Boosters
//
//  Created by Denys Danyliuk on 16.07.2022.
//

import SwiftUI
import ComposableArchitecture
import Kingfisher

struct AnimalFactView: View {

    let store: Store<AnimalFact.State, AnimalFact.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                RoundedRectangle(cornerRadius: 32)
                    .fill(.white)
                    .shadow(
                        color: .black.opacity(0.3),
                        radius: 20, x: 0, y: 5
                    )

                VStack {
                    GeometryReader { proxy in
                        KFImage.url(URL(string: viewStore.fact.image))
                            .resizable(resizingMode: .stretch)
                            .loadDiskFileSynchronously()
                            .diskCacheExpiration(.expired)
                            .memoryCacheExpiration(.expired)
                            .fade(duration: 0.25)
                            .placeholder { _ in
                                ProgressView()
                                    .progressViewStyle(.circular)
                            }
                            .scaledToFill()
                            .frame(width: proxy.size.width, height: 234)
                            .clipped()
                            .cornerRadius(16)
                    }
                    .frame(height: 234)

                    Text(viewStore.fact.fact)

                    Spacer()

                    HStack {
                        Button(
                            action: { viewStore.send(.previousButtonTapped) },
                            label: {
                                Image("arrowInCircle")
                                    .resizable()
                                    .frame(width: 44, height: 44)
                            }
                        )
                        .opacity(viewStore.previousButtonVisible ? 1 : 0)

                        Spacer()

                        Button(
                            action: { viewStore.send(.nextButtonTapped) },
                            label: {
                                Image("arrowInCircle")
                                    .resizable()
                                    .frame(width: 44, height: 44)
                                    .rotationEffect(.degrees(180))
                            }
                        )
                        .opacity(viewStore.nextButtonVisible ? 1 : 0)
                    }
                }
                .padding(16)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 70)
        }
    }

}

// MARK: - Preview

struct AnimalFactView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AnimalFactView(
                store: Store(
                    initialState: AnimalFact.State(fact: Animal.mock.content![0]),
                    reducer: AnimalFact.reducer,
                    environment: AnimalFact.Environment()
                )
            )
        }
    }
}
