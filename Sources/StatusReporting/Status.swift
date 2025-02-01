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

public enum StatusType: Codable, Hashable, Sendable {
    case error(String)
    case warning
    case success
}

public struct Status: Codable, Hashable, Identifiable, Sendable {
    
    public var id: UUID
    public var title: String
    public var message: String
    public var type: StatusType
    public var isReviewed: Bool
    
    public init(id: UUID = .init(), title: String, message: String, type: StatusType = .success, isReviewed: Bool = false) {
        self.id = id
        self.title = title
        self.message = message
        self.type = type
        self.isReviewed = isReviewed
    }
}

extension SharedKey where Self == InMemoryKey<IdentifiedArrayOf<Status>>.Default {
    public static var reportedStatus: Self {
        self[.inMemory("reportedStatus"), default: .init()]
    }
}

public func reportStatus(_ status: Status) {
    @Shared(.reportedStatus) var reportedStatus
    _ = $reportedStatus.withLock {
        $0.append(status)
    }
}

public func reportStatus(title: String, message: String, type: StatusType = .success) {
    reportStatus(Status(title: title, message: message, type: type))
}

public func markStatusAsReviewed(_ statusID: Status.ID, allowFeedback: Bool = true) {
    @Shared(.reportedStatus) var reportedStatus
    _ = $reportedStatus.withLock {
        $0[id: statusID]?.isReviewed = true
    }
}
