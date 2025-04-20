//
//  File.swift
//  swiftui-status-reporting
//
//  Created by Ratnesh Jain on 19/04/25.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct StatusItemView: View {
    let status: Status
    var animate: Bool = true
    let store: StoreOf<ReportedStatusFeature>
    @Environment(\.reportStatusViewConfiguration) var config
    @State private var showContent: Bool = false
    @State private var showImage: Bool = false
    
    var cornerRadius: CGFloat {
        self.showContent ? 38 : 42
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            if showImage {
                config.image(status)
                    .font(.title2)
                    .foregroundStyle(.primary)
                    .frame(width: 34, height: 34)
                    .padding(8)
                    .background(status.type.accentColor.secondary, in: .circle)
                    .transition(.scale)
            }
            if showContent {
                VStack(spacing: 8) {
                    config.content(status)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Spacer()
                        config.actions(status)
                            .buttonStyle(StatusButtonStyle(action: {
                                store.send(.user(.actionButtonTapped(status: status)))
                                stopTransition() {
                                    markStatusAsReviewed(status.id)
                                }
                            }))
                    }
                }
            }
        }
        .padding()
        .background(status.type.accentColor.tertiary, in: .rect(cornerRadius: cornerRadius))
        .background(Material.ultraThin, in: .rect(cornerRadius: cornerRadius))
        .overlay {
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(status.type.accentColor.secondary, lineWidth: 1)
        }
        .opacity(showImage ? 1 : 0)
        .clipShape(.rect(cornerRadius: cornerRadius))
        .shadow(color: Color.secondary.opacity(0.15), radius: 4)
        .onAppear {
            if animate {
                startTransition()
            } else {
                self.showContent = true
                self.showImage = true
            }
        }
        .padding()
    }
    
    func startTransition() {
        withAnimation(.smooth.delay(0.1)) {
            showImage = true
        } completion: {
            withAnimation(.smooth.delay(0.05)) {
                showContent = true
            }
        }
    }
    
    func stopTransition(completion: @escaping () -> Void) {
        withAnimation(.smooth.delay(0.1)) {
            showContent = false
        } completion: {
            withAnimation(.smooth.delay(0.05)) {
                showImage = false
            } completion: {
                completion()
            }
        }
    }
}

#Preview {
    StatusItemView(
        status: .init(
            title: "Error",
            message: "Something went wrong. Please try again using Retry button or contact Support.",
            type: .error("")
        ),
        store: .init(initialState: .init(), reducer: {
            ReportedStatusFeature()
        })
    )
    .preferredColorScheme(.dark)
}

#Preview("Multiple Statuses") {
    ZStack {
        StatusItemView(
            status: .init(
                title: "Error",
                message: "Something went wrong. Please try again using Retry button or contact Support.",
                type: .error("")
            ),
            animate: false,
            store: .init(initialState: .init(), reducer: {
                ReportedStatusFeature()
            })
        )
        .offset(y: -40)
        StatusItemView(
            status: .init(
                title: "Error",
                message: "Something went wrong. Please try again using Retry button or contact Support.",
                type: .error("")
            ),
            animate: false,
            store: .init(initialState: .init(), reducer: {
                ReportedStatusFeature()
            })
        )
        .offset(y: -30)
        StatusItemView(
            status: .init(
                title: "Error",
                message: "Something went wrong. Please try again using Retry button or contact Support.",
                type: .error("")
            ),
            animate: false,
            store: .init(initialState: .init(), reducer: {
                ReportedStatusFeature()
            })
        )
        .offset(y: -20)
        StatusItemView(
            status: .init(
                title: "Error",
                message: "Something went wrong. Please try again using Retry button or contact Support.",
                type: .error("")
            ),
            animate: false,
            store: .init(initialState: .init(), reducer: {
                ReportedStatusFeature()
            })
        )
        .offset(y: -10)
    }
}
