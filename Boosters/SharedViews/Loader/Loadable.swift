//
//  Loadable.swift
//  Boosters
//
//  Created by Denys Danyliuk on 15.07.2022.
//

import SwiftUI

struct Loadable: ViewModifier {

    @Binding var isVisible: Bool

    func body(content: Content) -> some View {
        ZStack {
            content
                .disabled(isVisible)
                .zIndex(0)

            if isVisible {
                Loader()
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.3)))
                    .zIndex(1)
            }
        }
    }
    
}

extension View {

    func loadable(_ isVisible: Binding<Bool>) -> some View {
        modifier(Loadable(isVisible: isVisible))
    }

}
