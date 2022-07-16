//
//  ActivityView.swift
//  Boosters
//
//  Created by Denys Danyliuk on 16.07.2022.
//

import SwiftUI

struct ActivityView: UIViewControllerRepresentable {

    let activityShareItem: ActivityShareItem

    func makeUIViewController(
        context: UIViewControllerRepresentableContext<ActivityView>
    ) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityShareItem.values, applicationActivities: nil)
    }

    func updateUIViewController(
        _ uiViewController: UIActivityViewController,
        context: UIViewControllerRepresentableContext<ActivityView>
    ) {

    }
    
}
