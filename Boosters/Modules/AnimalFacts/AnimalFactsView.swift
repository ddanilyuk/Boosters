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
                TabView {
                    ForEach(viewStore.animal.content ?? [], id: \.self) { fact in
                        card(for: fact)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 70)
                    }
                    .frame(
                        width: proxy.size.width,
                        height: proxy.size.height
                    )
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(viewStore.animal.title)
        }
    }

    func card(for fact: Fact) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(.purple.opacity(0.8))

            VStack {
                KFImage.url(URL(string: fact.image))
                    .resizable()
                    .loadDiskFileSynchronously()
                    .diskCacheExpiration(.expired)
                    .fade(duration: 0.25)
                    .placeholder { _ in
                        ProgressView()
                            .progressViewStyle(.circular)
                    }
                    .scaledToFill()
                    .frame(height: 234)
                    .clipped()

                Text(fact.fact)

                Spacer()

                HStack {
                    Text("Prev")
                    Spacer()
                    Text("Next")
                }
            }
            .padding()
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
