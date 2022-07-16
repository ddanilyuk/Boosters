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
                backgroundView

                VStack(spacing: 12) {
                    GeometryReader { proxy in
                        KFImage.url(viewStore.imageURL, cacheKey: viewStore.imageCacheKey)
                            .resizable()
                            .diskCacheExpiration(.expired)
                            .placeholder {
                                ZStack {
                                    Rectangle()
                                        .fill(Color(.systemGroupedBackground))

                                    ProgressView().progressViewStyle(.circular)
                                }
                            }
                            .scaledToFill()
                            .frame(width: proxy.size.width, height: 234)
                            .clipped()
                            .cornerRadius(20)
                            .overlay(alignment: .topTrailing) { shareMenu }
                    }
                    .frame(height: 234)

                    Text(viewStore.text)
                        .lineLimit(nil)
                        .frame(maxWidth: .infinity, alignment: .leading)

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
                .padding(12)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 70)
        }
    }

    var backgroundView: some View {
        RoundedRectangle(cornerRadius: 32)
            .fill(.white)
            .shadow(
                color: .black.opacity(0.3),
                radius: 20, x: 0, y: 5
            )
    }

    var shareMenu: some View {
        WithViewStore(store) { viewStore in
            Menu(
                content: {
                    Button(
                        action: { viewStore.send(.shareImageButtonTapped) },
                        label: {
                            Text("Image")
                            Image(systemName: "photo")
                        }
                    )
                    Button(
                        action: { viewStore.send(.shareTextButtonTapped) },
                        label: {
                            Text("Fact")
                            Image(systemName: "note.text")
                        }
                    )
                },
                label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.ultraThinMaterial)
                            .padding(2)

                        Image(systemName: "square.and.arrow.up")
                            .tint(Color.black)
                    }
                    .frame(width: 44, height: 44)
                    .padding(10)
                }
            )
        }
    }

}

// MARK: - Preview

struct AnimalFactView_Previews: PreviewProvider {

    static var previews: some View {
        NavigationView {
            AnimalFactView(
                store: Store(
                    initialState: AnimalFact.State(
                        fact: Animal.mock.content![0],
                        previousButtonVisible: true,
                        nextButtonVisible: true
                    ),
                    reducer: AnimalFact.reducer,
                    environment: AnimalFact.Environment(kingfisherService: .mock)
                )
            )
        }
    }
    
}
