//
//  SwiftUI+Navigation.swift
//  Boosters
//
//  Created by Denys Danyliuk on 15.07.2022.
//

import SwiftUI
import CasePaths

struct NavigationModifier<Value, WrappedDestination: View>: ViewModifier {

    let value: Binding<Value?>
    let destination: (Value) -> WrappedDestination

    public init(
        unwrapping value: Binding<Value?>,
        @ViewBuilder destination: @escaping (Value) -> WrappedDestination
    ) {
        self.value = value
        self.destination = destination
    }

    func body(content: Content) -> some View {
        ZStack {
            NavigationLink(
                destination: Binding(unwrapping: value)
                    .map { value in destination(value.wrappedValue) },
                isActive: value.isPresent(),
                label: { Text("") }
            )
            content
        }
    }

}

extension View {

    func navigationLink<Value, WrappedDestination: View>(
        unwrapping value: Binding<Value?>,
        @ViewBuilder destination: @escaping (Value) -> WrappedDestination
    ) -> some View {
        modifier(NavigationModifier(unwrapping: value, destination: destination))
    }

    func navigationLink<Enum, Case, WrappedDestination: View>(
        unwrapping enum: Binding<Enum?>,
        case casePath: CasePath<Enum, Case>,
        @ViewBuilder destination: @escaping (Case) -> WrappedDestination
    ) -> some View {
        modifier(NavigationModifier(
            unwrapping: `enum`.case(casePath),
            destination: destination
        ))
    }

}

extension Binding {

    init?(unwrapping base: Binding<Value?>) {
        self.init(unwrapping: base, case: /Optional.some)
    }

    init?<Enum>(unwrapping enum: Binding<Enum>, case casePath: CasePath<Enum, Value>) {
        guard var `case` = casePath.extract(from: `enum`.wrappedValue)
        else { return nil }

        self.init(
            get: {
                `case` = casePath.extract(from: `enum`.wrappedValue) ?? `case`
                return `case`
            },
            set: {
                `case` = $0
                `enum`.transaction($1).wrappedValue = casePath.embed($0)
            }
        )
    }

    func `case`<Enum, Case>(_ casePath: CasePath<Enum, Case>) -> Binding<Case?> where Value == Enum? {
        .init(
            get: { wrappedValue.flatMap(casePath.extract(from:)) },
            set: { newValue, transaction in
                self.transaction(transaction).wrappedValue = newValue.map(casePath.embed)
            }
        )
    }

    func isPresent<Wrapped>() -> Binding<Bool> where Value == Wrapped? {
        .init(
            get: {
                wrappedValue != nil
            },
            set: { isPresent, transaction in
                if !isPresent {
                    self.transaction(transaction).wrappedValue = nil
                }
            }
        )
    }

    func isPresent<Enum, Case>(_ casePath: CasePath<Enum, Case>) -> Binding<Bool> where Value == Enum? {
        self.case(casePath).isPresent()
    }

}
