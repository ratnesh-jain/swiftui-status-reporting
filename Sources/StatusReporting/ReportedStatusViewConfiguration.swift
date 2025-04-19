//
//  File.swift
//  swiftui-status-reporting
//
//  Created by Ratnesh Jain on 30/01/25.
//

import Foundation
import SwiftUI

/// This allows users to customize the visual appearance of the reported status view.
public struct ReportedStatusViewConfiguration {
    
    /// Customize the visual appearance of the left part image for given ``Status``.
    public var image: (Status) -> AnyView
    
    /// Customize the visual appearance of the content part for given ``Status``,
    public var content: (Status) -> AnyView
    
    /// Provide specific global actions views for given ``Status``.
    public var actions: (Status) -> AnyView
    
    /// Customize or limit the maxWidth of the status view for wider trait collection or for macOS wide screens.
    public var maxWidth: () -> CGFloat
}

extension ReportedStatusViewConfiguration: EnvironmentKey {
    
    /// Default Implementation for the ``ReportedStatusView``'s image, content, message views.
    public static var defaultValue: ReportedStatusViewConfiguration {
        .init { status in
            AnyView(
                Group {
                    switch status.type {
                    case .error:
                        Image(systemName: "exclamationmark.triangle.fill")
                    case .warning:
                        Image(systemName: "exclamationmark")
                    case .success:
                        Image(systemName: "checkmark")
                    }
                }
            )
        } content: { status in
            AnyView(
                VStack(alignment: .leading, spacing: 2) {
                    Text(status.title)
                        .fontWeight(.semibold)
                    Text(status.message)
                        .lineLimit(8, reservesSpace: false)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .opacity(0)
                        .overlay {
                            ScrollView {
                                Text(status.message)
                                    .foregroundStyle(.secondary)
                                    .font(.subheadline)
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .scrollBounceBehavior(.basedOnSize)
                        }
                }
            )
        } actions: { status in
            AnyView(
                Button("Okay") {}
            )
        } maxWidth: {
            340
        }
    }
}

extension EnvironmentValues {
    
    /// Environment Value entry for customizing the ``ReportedStatusView``'s visual appearance.
    public var reportStatusViewConfiguration: ReportedStatusViewConfiguration {
        get {
            self[ReportedStatusViewConfiguration.self]
        } set {
            self[ReportedStatusViewConfiguration.self] = newValue
        }
    }
}


extension View {
    
    /// Allow to provide application specific Image View or any indication view for given Status.
    /// - Parameter image: SwiftUI View for Image/Indication of given Status
    /// - Returns: Environment configured view for given Image.
    public func reportedStatusImage<Image: View>(@ViewBuilder _ image: @escaping (Status) -> Image) -> some View {
        self.environment(\.reportStatusViewConfiguration.image, { status in
            AnyView(image(status))
        })
    }
    
    /// Allow to provide application specific Content View for given ``Status``'s title and message.
    /// - Parameter image: SwiftUI View for Image/Indication of given Status
    /// - Returns: Environment configured view for given content.
    public func reportedStatusContent<Content: View>(@ViewBuilder _ content: @escaping (Status) -> Content) -> some View {
        self.environment(\.reportStatusViewConfiguration.content, { status in
            AnyView(content(status))
        })
    }
    
    /// Allow to provide application specific action views to handle reported ``Status``.
    /// - Parameter actions: Any View that can handle the given status.
    /// - Returns: Environment configured view for given actions.
    public func reportedStatusActions<Actions: View>(@ViewBuilder _ actions: @escaping (Status) -> Actions) -> some View {
        self.environment(\.reportStatusViewConfiguration.actions, { status in
            AnyView(actions(status))
        })
    }
}
