//
//  File.swift
//  swiftui-status-reporting
//
//  Created by Ratnesh Jain on 09/04/25.
//

import Foundation
import UIKit
import SwiftUI

struct WindowBridgeView<V: View>: UIViewRepresentable {
    
    var isPresenting: Bool
    @ViewBuilder var content: V
    
    func makeUIView(context: Context) -> WindowHelperView {
        WindowHelperView(
            isPresenting: isPresenting,
            content: EnvironmentPassingView(
                content: content,
                environment: context.environment
            )
        )
    }
    
    func updateUIView(_ uiView: WindowHelperView, context: Context) {
        uiView.setContent(
            isPresenting: isPresenting,
            content: EnvironmentPassingView(
                content: content,
                environment: context.environment
            )
        )
    }
    
    struct EnvironmentPassingView: View {
        var content: V
        var environment: EnvironmentValues
        
        var body: some View {
            content.environment(\.self, environment)
        }
    }
    
    class WindowHelperView: UIView {
        var isPresenting: Bool
        var content: EnvironmentPassingView
        private var overlayWindow: OverlayWindow?
        
        var hostingController: UIHostingController<EnvironmentPassingView>? {
            self.overlayWindow?.rootViewController as? UIHostingController<EnvironmentPassingView>
        }
        
        init(isPresenting: Bool, content: EnvironmentPassingView) {
            self.isPresenting = isPresenting
            self.content = content
            super.init(frame: .zero)
        }
        
        required init?(coder: NSCoder) {
            fatalError()
        }
        
        override func willMove(toWindow newWindow: UIWindow?) {
            super.willMove(toWindow: newWindow)
            if let windowScene = newWindow?.windowScene {
                let overlayWindow = OverlayWindow(windowScene: windowScene)
                self.overlayWindow = overlayWindow
                updateView()
            }
        }
        
        func setContent(isPresenting: Bool, content: EnvironmentPassingView) {
            self.isPresenting = isPresenting
            self.content = content
            updateView()
        }
        
        private func updateView() {
            if isPresenting {
                if hostingController == nil {
                    let controller = UIHostingController(rootView: content)
                    overlayWindow?.rootViewController = controller
                    overlayWindow?.rootViewController?.view.backgroundColor = .clear
                } else {
                    hostingController?.rootView = content
                }
                overlayWindow?.isHidden = false
            } else {
                overlayWindow?.rootViewController = nil
                overlayWindow?.isHidden = true
            }
        }
    }
}
