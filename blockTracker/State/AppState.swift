//
//  AppState.swift
//  blockTracker
//
//  Created by clement leclerc on 08/01/2026.
//

import Foundation

@Observable
class AppState {
    var selectedTab: MainTabView.Tab = .stats
    var sessionToShow: SessionModel?
}
