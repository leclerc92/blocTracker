//
//  ShareSheet.swift
//  blockTracker
//
//  Created by Claude Code on 08/01/2026.
//

import SwiftUI
import UIKit

/// Wrapper SwiftUI pour UIActivityViewController
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // Pas de mise à jour nécessaire
    }
}
