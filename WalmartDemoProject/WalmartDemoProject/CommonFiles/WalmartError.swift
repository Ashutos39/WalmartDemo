//
//  WalmartError.swift
//  WalmartDemoProject
//
//  Created by Ashutos Sahoo on 24/11/22.
//

import Foundation

enum WalmartError: Error {
    
    enum NetworkFailureReason {
        case timeout
        case internetUnavailable
        case networkConnectionLost
        case emptyResponse
        case general(description: String)
    }
    
    enum CoreDataFailureReason {
        case unableToFetch(String)
        case unableToSave(String)
        case storeUnavailable
        case storeURLUnavailable
    }
    
    case networkFailed(reason: NetworkFailureReason)
    case coreDataFailure(reason: CoreDataFailureReason)
    
    //TODO: this should not be used when proper error handling is integrated in the project
    case general(reason: String)
    
}

extension WalmartError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case let .networkFailed(reason):
            return reason.localizedDescription
        case let .coreDataFailure(reason):
            return reason.localizedDescription
        case let .general(reason):
            return reason
        }
    }
    
    var localizedDescription: String {
        return errorDescription ?? ""
    }
}

//MARK: - NetworkFailureReson -
extension WalmartError.NetworkFailureReason {
    
    var localizedDescription: String {
        switch self {
        case .timeout:
            return "URL request timed out"
        case .internetUnavailable:
            return "Internet is unavaialable"
        case .networkConnectionLost:
            return "The network connection was lost"
        case let .general(description):
            return description
        case .emptyResponse:
            return "Received empty response from server"
        }
    }
    
    static var defaultReason: WalmartError {
        return WalmartError.networkFailed(reason: WalmartError.NetworkFailureReason.general(description: "Something went wrong"))
    }
}


//MARK: - CoreDataFailureReason -
extension WalmartError.CoreDataFailureReason {
    
    var localizedDescription: String {
        
        switch self {
        case let .unableToFetch(reason):
            return reason
        case let .unableToSave(reason):
            return reason
        case .storeUnavailable:
            return "Invalid or missing core data store"
        case .storeURLUnavailable:
            return "Invalid or missing core data store url"
        }
    }
}


//MARK: - Error -
extension Error {
    
    var asWalmartError: WalmartError? {
        self as? WalmartError
    }
    
    func asWalmartError(orFailWith message: @autoclosure () -> String, file: StaticString = #file, line: UInt = #line) -> WalmartError {
        guard let afError = self as? WalmartError else {
            fatalError(message(), file: file, line: line)
        }
        return afError
    }
    
    func asWalmartError(or defaultWalmartError: @autoclosure () -> WalmartError) -> WalmartError {
        self as? WalmartError ?? defaultWalmartError()
    }
}
