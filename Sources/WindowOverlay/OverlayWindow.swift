//
//  File.swift
//  swiftui-status-reporting
//
//  Created by Ratnesh Jain on 09/04/25.
//

import Foundation
import UIKit

class OverlayWindow: UIWindow {
    override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
        self.windowLevel = .alert
    }
    
    required init?(coder: NSCoder) {
        fatalError("Use init(windowScene:) instead")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let rootViewController, let view = super.hitTest(point, with: event) else {
            return nil
        }
        
        if view == rootViewController.view {
            if view.colorOfPoint(point).alpha < 0.01 {
                return nil
            }
        }
        
        return view
    }
}

extension UIView {
    func colorOfPoint(_ point: CGPoint) -> UIColor {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        var pixelData = [UInt8](repeating: 0, count: 4)
        let context = CGContext(data: &pixelData, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context?.translateBy(x: -point.x, y: -point.y)
        
        self.layer.render(in: context!)
        
        let color = UIColor(red: CGFloat(pixelData[0]) / 255.0, green: CGFloat(pixelData[1]) / 255.0, blue: CGFloat(pixelData[2]) / 255.0, alpha: CGFloat(pixelData[3]) / 255.0)
        
        return color
    }
}

extension UIColor {
    var alpha: CGFloat {
        return self.cgColor.alpha
    }
}
