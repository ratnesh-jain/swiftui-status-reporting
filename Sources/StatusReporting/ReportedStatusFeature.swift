//
//  File.swift
//  swiftui-status-reporting
//
//  Created by Ratnesh Jain on 30/01/25.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct ReportedStatusFeature {
    @ObservableState
    public struct State: Equatable {
        @Shared(.reportedStatus) var reportedStatus
        var showAllStatus: Bool = false
        var showContent: Bool = false
        
        var firstStatus: Status? {
            reportedStatus.first(where: {$0.isReviewed == false})
        }
        
        public init() {}
    }
    
    public enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
    }
}
