//
//  AnimalsListTests.swift
//  BoostersTests
//
//  Created by Denys Danyliuk on 17.07.2022.
//

import ComposableArchitecture
import XCTest
@testable import Boosters

class AnimalsListTests: XCTestCase {

    func testGetAnimalsSuccess() throws {
        let animals = [Animal.mock]
        var animalsService = AnimalsService.unimplemented
        animalsService.getAnimals = {
            Effect(value: animals)
        }

        let store = TestStore(
            initialState: AnimalsList.State(),
            reducer: AnimalsList.reducer,
            environment: AnimalsList.Environment(
                mainQueue: .immediate.eraseToAnyScheduler(),
                animalsService: animalsService,
                kingfisherService: .mock
            )
        )

        store.send(.onAppear) {
            $0.isLoading = true
        }

        store.receive(.getAnimalsResponse(.success(animals))) {
            $0.isLoading = false
            $0.isLoaded = true
            $0.animals = IdentifiedArrayOf(uniqueElements: animals.sorted())
            $0.animalsCells = IdentifiedArrayOf(
                uniqueElements: $0.animals.map { AnimalCell.State(animal: $0) }
            )
        }
    }

    func testGetAnimalsFailure() throws {
        var animalsService = AnimalsService.unimplemented
        let networkError = NetworkError.apiError(message: "Test error message")
        animalsService.getAnimals = {
            Effect(error: networkError)
        }

        let store = TestStore(
            initialState: AnimalsList.State(),
            reducer: AnimalsList.reducer,
            environment: AnimalsList.Environment(
                mainQueue: .immediate.eraseToAnyScheduler(),
                animalsService: animalsService,
                kingfisherService: .mock
            )
        )

        store.send(.onAppear) {
            $0.isLoading = true
        }

        store.receive(.getAnimalsResponse(.failure(networkError))) {
            $0.isLoading = false
            $0.alert = AlertState(
                title: TextState("Oooops Error"),
                message: TextState(networkError.description),
                dismissButton: .default(TextState("Ok"))
            )
        }
    }

    func testFreeAnimalSelection() throws {

        let freeAnimal = Animal(
            title: "Cats",
            description: "Different facts about free animal",
            image: "https://upload.wikimedia.org/wikipedia/commons/2/2b/WelshCorgi.jpeg",
            order: 2,
            status: .free,
            content: [
                Fact(
                    fact: "During the Renaissance, detailed portraits of the dog as a symbol of fidelity and loyalty appeared in mythological, allegorical, and religious art throughout Europe, including works by Leonardo da Vinci, Diego Velázquez, Jan van Eyck, and Albrecht Durer. ",
                    image: "https://images.dog.ceo/breeds/basenji/n02110806_4150.jpg"
                )
            ]
        )

        let animals = [freeAnimal]

        var animalsService = AnimalsService.unimplemented
        animalsService.getAnimals = {
            Effect(value: animals)
        }

        let store = TestStore(
            initialState: AnimalsList.State(),
            reducer: AnimalsList.reducer,
            environment: AnimalsList.Environment(
                mainQueue: .immediate.eraseToAnyScheduler(),
                animalsService: animalsService,
                kingfisherService: .mock
            )
        )

        // View appears
        store.send(.onAppear) {
            $0.isLoading = true
        }

        // Receive animals
        store.receive(.getAnimalsResponse(.success(animals))) {
            $0.isLoading = false
            $0.isLoaded = true
            $0.animals = IdentifiedArrayOf(uniqueElements: animals.sorted())
            $0.animalsCells = IdentifiedArrayOf(
                uniqueElements: $0.animals.map { AnimalCell.State(animal: $0) }
            )
        }

        // Tap on free animal
        store.send(.animalsCells(id: freeAnimal.id, action: .onTap))

        // Details opened
        store.receive(.openDetails(animal: freeAnimal)) {
            $0.selectedAnimalFacts = AnimalFacts.State(animal: freeAnimal)
        }
    }

    func testPaidAnimalSelection() throws {

        let paidAnimal = Animal(
            title: "Dogs",
            description: "Different facts about dogs",
            image: "https://upload.wikimedia.org/wikipedia/commons/2/2b/WelshCorgi.jpeg",
            order: 2,
            status: .paid,
            content: [
                Fact(
                    fact: "During the Renaissance, detailed portraits of the dog as a symbol of fidelity and loyalty appeared in mythological, allegorical, and religious art throughout Europe, including works by Leonardo da Vinci, Diego Velázquez, Jan van Eyck, and Albrecht Durer. ",
                    image: "https://images.dog.ceo/breeds/basenji/n02110806_4150.jpg"
                )
            ]
        )

        let animals = [paidAnimal]

        var animalsService = AnimalsService.unimplemented
        animalsService.getAnimals = {
            Effect(value: animals)
        }

        let mainQueue = DispatchQueue.test
        let store = TestStore(
            initialState: AnimalsList.State(),
            reducer: AnimalsList.reducer,
            environment: AnimalsList.Environment(
                mainQueue: mainQueue.eraseToAnyScheduler(),
                animalsService: animalsService,
                kingfisherService: .mock
            )
        )

        // View appears
        store.send(.onAppear) {
            $0.isLoading = true
        }

        // Make request perform
        mainQueue.advance()

        // Receive animals
        store.receive(.getAnimalsResponse(.success(animals))) {
            $0.isLoading = false
            $0.isLoaded = true
            $0.animals = IdentifiedArrayOf(uniqueElements: animals.sorted())
            $0.animalsCells = IdentifiedArrayOf(
                uniqueElements: $0.animals.map { AnimalCell.State(animal: $0) }
            )
        }

        // Tap on paid animal
        store.send(.animalsCells(id: paidAnimal.id, action: .onTap)) {
            $0.alert = AlertState(
                title: TextState("Watch Ad to continue"),
                primaryButton: .default(
                    TextState("Show Ad"),
                    action: .send(.showAd(animal: paidAnimal))
                ),
                secondaryButton: .cancel(TextState("Cancel"))
            )
        }

        // Tap on show ad
        store.send(.showAd(animal: paidAnimal)) {
            $0.isLoading = true
        }

        // Wait 2 seconds
        mainQueue.advance(by: 2)

        // Details opened
        store.receive(.openDetails(animal: paidAnimal)) {
            $0.isLoading = false
            $0.selectedAnimalFacts = AnimalFacts.State(animal: paidAnimal)
        }
    }

    func testComingSoonAnimalSelection() throws {
        let comingSoonAnimal = Animal(
            title: "Coming soon",
            description: "Different facts about panda",
            image: "https://upload.wikimedia.org/wikipedia/commons/2/2b/WelshCorgi.jpeg",
            order: 2,
            status: .comingSoon,
            content: []
        )

        let animals = [comingSoonAnimal]

        var animalsService = AnimalsService.unimplemented
        animalsService.getAnimals = {
            Effect(value: animals)
        }

        let mainQueue = DispatchQueue.test
        let store = TestStore(
            initialState: AnimalsList.State(),
            reducer: AnimalsList.reducer,
            environment: AnimalsList.Environment(
                mainQueue: mainQueue.eraseToAnyScheduler(),
                animalsService: animalsService,
                kingfisherService: .mock
            )
        )

        // View appears
        store.send(.onAppear) {
            $0.isLoading = true
        }

        // Make request perform
        mainQueue.advance()

        // Receive animals
        store.receive(.getAnimalsResponse(.success(animals))) {
            $0.isLoading = false
            $0.isLoaded = true
            $0.animals = IdentifiedArrayOf(uniqueElements: animals.sorted())
            $0.animalsCells = IdentifiedArrayOf(
                uniqueElements: $0.animals.map { AnimalCell.State(animal: $0) }
            )
        }

        // Tap on coming soon animal
        store.send(.animalsCells(id: comingSoonAnimal.id, action: .onTap)) {
            $0.alert = AlertState(
                title: TextState("Coming soon"),
                dismissButton: .default(TextState("Ok"))
            )
        }
    }

}

extension AnimalsService {

    static let unimplemented = Self(
        getAnimals: { .unimplemented("\(Self.self).getAnimals") }
    )

}
