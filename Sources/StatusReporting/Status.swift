//
//  File.swift
//  swiftui-status
//
//  Created by Ratnesh Jain on 30/01/25.
//

import Dependencies
import Foundation
import IdentifiedCollections
import Sharing
import SensoryFeedbackClient
import UIKit

/// Type of status that are reported using ``reportStatus``
public enum StatusType: Codable, Hashable, Sendable {
    case error(String)
    case warning
    case success
}

/// This type allows to construct a user facing status
/// it case be a success status, warning status or error status which can be occured from any operation.
public struct Status: Codable, Hashable, Identifiable, Sendable, Error {
    public var id: UUID
    public var title: String
    public var message: String
    public var type: StatusType
    public var reportDate: Date
    public var isReviewed: Bool
    
    public init(id: UUID = .init(), title: String, message: String, type: StatusType = .success, isReviewed: Bool = false) {
        self.id = id
        self.title = title
        self.message = message
        self.type = type
        self.reportDate = Date()
        self.isReviewed = isReviewed
    }
}

extension SharedKey where Self == InMemoryKey<Status?>.Default {
    public static var latestStatus: Self {
        self[.inMemory("latestStatus"), default: nil]
    }
}

extension SharedKey where Self == InMemoryKey<IdentifiedArrayOf<Status>>.Default {
    /// A global context aware thread safe in memory array of reported status via  ``reportStatus`` method.
    public static var reportedStatus: Self {
        self[.inMemory("reportedStatus"), default: .init()]
    }
}

