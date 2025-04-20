//
//  File.swift
//  swiftui-status-reporting
//
//  Created by Ratnesh Jain on 09/04/25.
//

import Foundation
import SwiftUI

extension View {
    public func windowOverlay<Content: View>(isPresenting: Bool, @ViewBuilder _ content: @escaping () -> Content) -> some View {
        self.background {
            WindowBridgeView(isPresenting: isPresenting, content: content)
        }
    }
    
    public func windowOverlay<Content: View, Item: Hashable>(item: Item?, @ViewBuilder _ content: @escaping () -> Content) -> some View {
        self.modifier(WindowBackgroundModifier(view: content, item: item))
    }
}

struct WindowBackgroundModifier<V: View, Item: Hashable>: ViewModifier {
    @ViewBuilder var view: () -> V
    var item: Item?
    @State var isPresenting: Bool = false
    
    func body(content: Content) -> some View {
        content
            .background {
                WindowBridgeView(isPresenting: isPresenting, content: view)
            }
            .onChange(of: item) { oldValue, newValue in
                if oldValue != newValue, newValue != nil {
                    isPresenting = true
                    //withAnimation(.smooth.delay(0.2)) {
                    //    isPresenting = true
                    //}
                } else if newValue == nil {
                    isPresenting = false
                }
            }
    }
}
