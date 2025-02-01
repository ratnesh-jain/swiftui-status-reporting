//
//  File.swift
//  swiftui-status-reporting
//
//  Created by Ratnesh Jain on 01/02/25.
//

import Foundation
import IssueReporting
import Sharing

/// This type conforms to ``IssueReporting.IssueReporter`` to show these reported issue as a `reportedStatus`. 
public struct StatusReporter: IssueReporter {
    public init() {}
    
    /// Called when an issue is reported.
    ///
    /// - Parameters:
    ///   - message: A message describing the issue.
    ///   - fileID: The source `#fileID` associated with the issue.
    ///   - filePath: The source `#filePath` associated with the issue.
    ///   - line: The source `#line` associated with the issue.
    ///   - column: The source `#column` associated with the issue.
    public func reportIssue(_ message: @autoclosure () -> String?, fileID: StaticString, filePath: StaticString, line: UInt, column: UInt) {
        reportStatus(title: "Issue Reported", message: message() ?? "", type: .warning)
    }
    
    /// Called when an error is caught.
    ///
    /// The default implementation of this conformance simply calls
    /// ``reportIssue(_:fileID:filePath:line:column:)`` with a description of the error.
    ///
    /// - Parameters:
    ///   - error: An error.
    ///   - message: A message describing the issue.
    ///   - fileID: The source `#fileID` associated with the issue.
    ///   - filePath: The source `#filePath` associated with the issue.
    ///   - line: The source `#line` associated with the issue.
    ///   - column: The source `#column` associated with the issue.
    public func reportIssue(_ error: any Error, _ message: @autoclosure () -> String?, fileID: StaticString, filePath: StaticString, line: UInt, column: UInt) {
        reportStatus(title: "Error reported", message: message() ?? "" + error.localizedDescription, type: .error(error.localizedDescription))
    }
    
    /// Called when an expected issue is reported.
    ///
    /// The default implementation of this conformance simply ignores the issue.
    ///
    /// - Parameters:
    ///   - message: A message describing the issue.
    ///   - fileID: The source `#fileID` associated with the issue.
    ///   - filePath: The source `#filePath` associated with the issue.
    ///   - line: The source `#line` associated with the issue.
    ///   - column: The source `#column` associated with the issue.
    public func expectIssue(_ message: @autoclosure () -> String?, fileID: StaticString, filePath: StaticString, line: UInt, column: UInt) {
        reportStatus(title: "Error Occured", message: message() ?? "", type: .warning)
    }
    
    /// Called when an expected error is reported.
    ///
    /// The default implementation of this conformance simply ignores the error.
    ///
    /// - Parameters:
    ///   - error: An error.
    ///   - message: A message describing the issue.
    ///   - fileID: The source `#fileID` associated with the issue.
    ///   - filePath: The source `#filePath` associated with the issue.
    ///   - line: The source `#line` associated with the issue.
    ///   - column: The source `#column` associated with the issue.
    public func expectIssue(_ error: any Error, _ message: @autoclosure () -> String?, fileID: StaticString, filePath: StaticString, line: UInt, column: UInt) {
        reportStatus(title: "Error occurred", message: (message() ?? "") + error.localizedDescription, type: .error(error.localizedDescription))
    }
}
