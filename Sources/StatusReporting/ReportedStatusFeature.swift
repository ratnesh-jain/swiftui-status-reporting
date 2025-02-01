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
    
    @Dependency(\.sensoryFeedback) var feedback
    
    public enum Action: Equatable, BindableAction {
        public enum SystemAction: Equatable {
            case onAppear
        }
        public enum UserAction: Equatable {
            case actionButtonTapped(status: Status)
        }
        case binding(BindingAction<State>)
        case system(SystemAction)
        case user(UserAction)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce<State, Action> { state, action in
            switch action {
            case .binding:
                return .none
            case .system(.onAppear):
                if feedback.allowFeedback() {
                    switch state.firstStatus?.type {
                    case .error:
                        feedback.notify(type: .error)
                    case .warning:
                        feedback.notify(type: .warning)
                    case .success:
                        feedback.notify(type: .success)
                    case .none:
                        break
                    }
                }
                return .none
            case .user(.actionButtonTapped(let status)):
                if feedback.allowFeedback() {
                    feedback.impact(style: .soft, intesity: 1)
                }
                return .none
            }
        }
    }
}
