//
//  Loader.swift
//  Boosters
//
//  Created by Denys Danyliuk on 15.07.2022.
//

import SwiftUI

struct Loader: View {

    var body: some View {
        ZStack {
            Color.secondary.opacity(0.3)

            ProgressView("Loading...")
                .foregroundColor(Color.blue)
                .font(.caption)
                .tint(Color.blue)
                .controlSize(.large)
                .scaleEffect(1.5)
                .progressViewStyle(.circular)
        }
        .edgesIgnoringSafeArea(.all)
    }

}
