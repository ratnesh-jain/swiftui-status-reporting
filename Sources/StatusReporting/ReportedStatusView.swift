//
//  File.swift
//  swiftui-status-reporting
//
//  Created by Ratnesh Jain on 30/01/25.
//

import ComposableArchitecture
import Foundation
import SwiftUI

/// Primary SwiftUI View to present reported ``Status``.
public struct ReportedStatusView: View {
    let store: StoreOf<ReportedStatusFeature>
    @Environment(\.reportStatusViewConfiguration) var config
    
    var cornerRadius: CGFloat {
        store.showContent ? 20 : 42
    }
    
    public init(store: StoreOf<ReportedStatusFeature>) {
        self.store = store
    }
    
    public var body: some View {
        ZStack {
            if let first = store.firstStatus {
                HStack(alignment: .top, spacing: 8) {
                    config.image(first)
                        .font(.title2)
                        .foregroundStyle(.primary)
                        .frame(width: 34, height: 34)
                        .padding(8)
                        .background(first.type.accentColor.secondary, in: .circle)
                    if store.showContent {
                        VStack(spacing: 8) {
                            config.content(first)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            HStack {
                                Spacer()
                                config.actions(first)
                                    .buttonStyle(StatusButtonStyle(action: {
                                        store.send(.user(.actionButtonTapped(status: first)))
                                        withAnimation(.smooth) {
                                            store.showContent = false
                                        } completion: {
                                            markStatusAsReviewed(first.id)
                                            store.send(.system(.disappeared))
                                        }
                                    }))
                            }
                        }
                        .frame(maxWidth: config.maxWidth())
                        .transition(.opacity)
                    }
                }
                .padding()
                .clipShape(.rect(cornerRadius: cornerRadius))
                .background(Material.bar, in: .rect(cornerRadius: cornerRadius))
                .background(first.type.accentColor.tertiary, in: .rect(cornerRadius: cornerRadius))
                .overlay {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(first.type.accentColor.secondary, lineWidth: 1)
                }
                .padding()
                .onAppear {
                    store.send(.system(.onAppear))
                    withAnimation(.smooth.delay(0.35)) {
                        store.showContent = true
                    } completion: {
                        store.send(.system(.initialAnimationCompleted))
                    }
                }
                .transition(.scale.combined(with: .opacity))
                .id(first.id)
            }
        }
        .animation(.smooth, value: store.firstStatus)
        .onChange(of: store.firstStatus) { oldValue, newValue in
            if newValue != nil {
                store.send(.system(.willAppear))
            }
        }
    }
}

extension StatusType {
    var accentColor: Color {
        switch self {
        case .error: .red
        case .warning: .yellow
        case .success: .green
        }
    }
}

extension View {
    
    /// Allows to display reported Status using ``ReportedStatusView`` as an overlay at the level of Application's root view.
    /// - Parameters:
    ///   - alignment: Aligment to where to display overlay of reported status's view.
    ///   - store: An Composable architecture store for parent to observe and handle reported statuses.
    /// - Returns: Root view with overlayedd ``ReportedStatusView``.
    public func showReportedStatus(alignment: Alignment = .bottom, store: StoreOf<ReportedStatusFeature> = .init(initialState: .init()) {
        ReportedStatusFeature()
    }) -> some View {
        self.overlay(alignment: alignment) {
            ReportedStatusView(store: store)
        }
    }
}

#Preview {
    List(1...20, id: \.self) { index in
        Text("Index: \(index)")
            .contextMenu {
                Button("Add to Cart") {
                    reportStatus(title: "Actions completed", message: "Item added to cart", type: .success)
                }
                Button("Checkout") {
                    reportStatus(title: "Error Occured Performing action", message: "Unknwon error occurred please try again later", type: .error(""))
                }
                Button("Bookmark") {
                    reportStatus(title: "Could not add to bookmark", message: "We got some error bookmarking item, its not your fault. Give it another try.", type: .warning)
                }
            }
    }
    .buttonStyle(.bordered)
    .showReportedStatus(alignment: .top)
    .reportedStatusActions({ status in
        switch status.type {
        case .error:
            Button("Contact Support") {}
                .foregroundStyle(Color.accentColor)
        case .warning:
            Button("Okay") {}
        case .success:
            Button("Great") {}
        }
    })
    .preferredColorScheme(.dark)
}
