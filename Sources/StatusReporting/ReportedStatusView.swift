//
//  File.swift
//  swiftui-status-reporting
//
//  Created by Ratnesh Jain on 30/01/25.
//

import ComposableArchitecture
import Foundation
import SwiftUI

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
                    }
                }
                .transition(.scale.combined(with: .opacity))
                .id(first.id)
            }
        }
        .animation(.smooth, value: store.firstStatus)
    }
}

struct StatusButtonStyle: ButtonStyle {
    var action: () -> Void
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(8)
            .padding(.horizontal, 4)
            .background(.quaternary, in: Capsule())
            .opacity(configuration.isPressed ? 0.5 : 1)
            .onChange(of: configuration.isPressed) { oldValue, newValue in
                if oldValue == true && newValue == false {
                    action()
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
