//
//  View+ReportStatus.swift
//  swiftui-status-reporting
//
//  Created by Ratnesh Jain on 19/04/25.
//

import ComposableArchitecture
import SwiftUI
import WindowOverlay

extension View {
    
    /// Allows to display reported Status using ``ReportedStatusView`` as an overlay at the level of Application's root view.
    /// - Parameters:
    ///   - alignment: Aligment to where to display overlay of reported status's view.
    ///   - store: An Composable architecture store for parent to observe and handle reported statuses.
    /// - Returns: Root view with overlayedd ``ReportedStatusView``.
    public func showReportedStatus(alignment: Alignment = .bottom, store: StoreOf<ReportedStatusFeature>) -> some View {
        self.windowOverlay(item: store.allStatus + [store.latestStatus]) {
            Color.clear
                .overlay(alignment: alignment) {
                    ReportedStatusView(store: store)
                }
                .id("ReportedStatusWindowOverlayContent")
        }
    }
}
