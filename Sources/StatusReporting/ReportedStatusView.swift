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
    
    public init(store: StoreOf<ReportedStatusFeature>) {
        self.store = store
    }
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            if let latest = store.latestStatus, store.startTransition {
                StatusItemView(status: latest, store: store)
                    .id(latest.id)
                    .zIndex(CGFloat(store.allStatus.count + 1))
            }
            if !store.allStatus.isEmpty {
                ZStack {
                    ForEach(Array(store.allStatus.enumerated()), id: \.element.id) { (idx, status) in
                        StatusItemView(status: status, animate: false, store: store)
                            .offset(y: CGFloat(store.allStatus.count - idx) * 10)
                            .zIndex(CGFloat(idx))
                    }
                }
                .animation(.smooth, value: store.allStatus.count)
            }
        }
        .onAppear {
            store.send(.system(.willAppear))
            Task {
                try? await Task.sleep(for: .seconds(0.2))
                withAnimation(.smooth) {
                    store.startTransition = true
                }
            }
        }
        .animation(.smooth, value: store.latestStatus)
        .onChange(of: store.latestStatus) { oldValue, newValue in
            if newValue != nil {
                store.send(.system(.willAppear))
                Task {
                    try? await Task.sleep(for: .seconds(0.2))
                    withAnimation(.smooth) {
                        store.startTransition = true
                    }
                }
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
    .showReportedStatus(alignment: .top, store: .init(initialState: .init(), reducer: {
        ReportedStatusFeature()
    }))
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
