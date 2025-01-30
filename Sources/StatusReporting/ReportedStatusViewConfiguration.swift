//
//  File.swift
//  swiftui-status-reporting
//
//  Created by Ratnesh Jain on 30/01/25.
//

import Foundation
import SwiftUI

public struct ReportedStatusViewConfiguration {
    public var image: (Status) -> AnyView
    public var content: (Status) -> AnyView
    public var actions: (Status) -> AnyView
    public var maxWidth: () -> CGFloat
}

extension ReportedStatusViewConfiguration: EnvironmentKey {
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
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
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
    public var reportStatusViewConfiguration: ReportedStatusViewConfiguration {
        get {
            self[ReportedStatusViewConfiguration.self]
        } set {
            self[ReportedStatusViewConfiguration.self] = newValue
        }
    }
}


extension View {
    public func reportedStatusImage<Image: View>(@ViewBuilder _ image: @escaping (Status) -> Image) -> some View {
        self.environment(\.reportStatusViewConfiguration.image, { status in
            AnyView(image(status))
        })
    }
    
    public func reportedStatusContent<Content: View>(@ViewBuilder _ content: @escaping (Status) -> Content) -> some View {
        self.environment(\.reportStatusViewConfiguration.content, { status in
            AnyView(content(status))
        })
    }
    
    public func reportedStatusActions<Actions: View>(@ViewBuilder _ actions: @escaping (Status) -> Actions) -> some View {
        self.environment(\.reportStatusViewConfiguration.actions, { status in
            AnyView(actions(status))
        })
    }
}
