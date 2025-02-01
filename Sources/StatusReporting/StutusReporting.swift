//
//  File.swift
//  swiftui-status-reporting
//
//  Created by Ratnesh Jain on 01/02/25.
//

import Foundation
import Sharing

/// Report a caught error.
///
/// This function behaves similarly to ``reportIssue(_:fileID:filePath:line:column:)``, but for
/// reporting errors.


/// Report a status of either success, warning or error.
/// - Parameter status: A type that represent the success, warning or error status in a user friendly way
public func reportStatus(_ status: Status) {
    @Shared(.reportedStatus) var reportedStatus
    _ = $reportedStatus.withLock {
        $0.append(status)
    }
}

/// Report a status of either success, warning or error.
/// - Parameter title: Title of the success, warning or error status.
/// - Parameter message: User friendly message representing underlying error.
/// - Parameter type: Differentiate between reported status is success, warning or error.
public func reportStatus(title: String, message: String, type: StatusType = .success) {
    reportStatus(Status(title: title, message: message, type: type))
}

/// Marks reported status as reviewed by user.
/// - Parameters:
///   - statusID: ID of the reported status
public func markStatusAsReviewed(_ statusID: Status.ID) {
    @Shared(.reportedStatus) var reportedStatus
    _ = $reportedStatus.withLock {
        $0[id: statusID]?.isReviewed = true
    }
}
