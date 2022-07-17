//
//  AnimalFactsTests.swift
//  BoostersTests
//
//  Created by Denys Danyliuk on 17.07.2022.
//

import ComposableArchitecture
import XCTest
@testable import Boosters

class AnimalFactsTests: XCTestCase {

    func testAnimalFactsNext() throws {

        let fact1 = Fact(
            fact: "During the Renaissance, detailed portraits of the dog as a symbol of fidelity and loyalty appeared in mythological, allegorical, and religious art throughout Europe, including works by Leonardo da Vinci, Diego Velázquez, Jan van Eyck, and Albrecht Durer. ",
            image: "https://images.dog.ceo/breeds/basenji/n02110806_4150.jpg"
        )
        let fact2 = Fact(
            fact: "Scholars have argued over the metaphysical interpretation of Dorothy’s pooch, Toto, in the Wizard of Oz. One theory postulates that Toto represents Anubis, the dog-headed Egyptian god of death, because Toto consistently keeps Dorothy from safely returning home",
            image: "https://images.dog.ceo/breeds/terrier-kerryblue/n02093859_2526.jpg"
        )
        let fact3 = Fact(
            fact: "Dogs often bury bones so that they can dig them up at some moment in the future when they are hungry.",
            image: "https://images.dog.ceo/breeds/greyhound-italian/n02091032_6979.jpg"
        )
        let animal = Animal(
            title: "Horses 🐕",
            description: "Different facts about horses",
            image: "https://upload.wikimedia.org/wikipedia/commons/2/2b/WelshCorgi.jpeg",
            order: 2,
            status: .paid,
            content: [fact1, fact2, fact3]
        )
        let store = TestStore(
            initialState: AnimalFacts.State(
                animal: animal
            ),
            reducer: AnimalFacts.reducer,
            environment: AnimalFacts.Environment(
                kingfisherService: .mock
            )
        )

        store.send(.animalFacts(id: fact1.id, action: .nextButtonTapped))

        store.receive(.animalFacts(id: fact1.id, action: .delegate(.nextFact))) {
            $0.selectedFactID = fact2.id
        }

        store.send(.animalFacts(id: fact2.id, action: .nextButtonTapped))

        store.receive(.animalFacts(id: fact2.id, action: .delegate(.nextFact))) {
            $0.selectedFactID = fact3.id
        }
    }

    func testAnimalFactsPrevious() throws {

        let fact1 = Fact(
            fact: "During the Renaissance, detailed portraits of the dog as a symbol of fidelity and loyalty appeared in mythological, allegorical, and religious art throughout Europe, including works by Leonardo da Vinci, Diego Velázquez, Jan van Eyck, and Albrecht Durer. ",
            image: "https://images.dog.ceo/breeds/basenji/n02110806_4150.jpg"
        )
        let fact2 = Fact(
            fact: "Scholars have argued over the metaphysical interpretation of Dorothy’s pooch, Toto, in the Wizard of Oz. One theory postulates that Toto represents Anubis, the dog-headed Egyptian god of death, because Toto consistently keeps Dorothy from safely returning home",
            image: "https://images.dog.ceo/breeds/terrier-kerryblue/n02093859_2526.jpg"
        )
        let fact3 = Fact(
            fact: "Dogs often bury bones so that they can dig them up at some moment in the future when they are hungry.",
            image: "https://images.dog.ceo/breeds/greyhound-italian/n02091032_6979.jpg"
        )
        let animal = Animal(
            title: "Horses 🐕",
            description: "Different facts about horses",
            image: "https://upload.wikimedia.org/wikipedia/commons/2/2b/WelshCorgi.jpeg",
            order: 2,
            status: .paid,
            content: [fact1, fact2, fact3]
        )
        let store = TestStore(
            initialState: AnimalFacts.State(
                animal: animal
            ),
            reducer: AnimalFacts.reducer,
            environment: AnimalFacts.Environment(
                kingfisherService: .mock
            )
        )

        store.send(.animalFacts(id: fact3.id, action: .previousButtonTapped))

        store.receive(.animalFacts(id: fact3.id, action: .delegate(.previousFact))) {
            $0.selectedFactID = fact2.id
        }

        store.send(.animalFacts(id: fact2.id, action: .previousButtonTapped))

        store.receive(.animalFacts(id: fact2.id, action: .delegate(.previousFact))) {
            $0.selectedFactID = fact1.id
        }
    }

}
