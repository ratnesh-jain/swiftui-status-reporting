//
//  File.swift
//  swiftui-status-reporting
//
//  Created by Ratnesh Jain on 30/01/25.
//

import ComposableArchitecture
import Foundation

/// Reducer for handling the reported status and user action with transition events.
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
        public enum DelegateAction: Equatable {
            case statusWillDisplay
            case statusDisplaying
            case statusDisplayed
            case statusDisappearing
            case statusDisappeared
            case userPerformingAction(status: Status)
        }
        
        public enum SystemAction: Equatable {
            case willAppear
            case onAppear
            case initialAnimationCompleted
            case disappeared
        }
        
        public enum UserAction: Equatable {
            case actionButtonTapped(status: Status)
        }
        
        case binding(BindingAction<State>)
        case delegate(DelegateAction)
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
                
            case .delegate:
                return .none
                
            case .system(.willAppear):
                return .send(.delegate(.statusWillDisplay))
                
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
                return .send(.delegate(.statusDisplaying))
                
            case .system(.initialAnimationCompleted):
                return .send(.delegate(.statusDisplayed))
                
            case .system(.disappeared):
                return .send(.delegate(.statusDisappeared))
                
            case .user(.actionButtonTapped(_)):
                if feedback.allowFeedback() {
                    feedback.impact(style: .soft, intesity: 1)
                }
                return .send(.delegate(.statusDisappearing))
            }
        }
    }
}
