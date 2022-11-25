//
//  WalmartCoreDataStoreType.swift
//  WalmartDemoProject
//
//  Created by Ashutos Sahoo on 24/11/22.
//

import Foundation

import CoreData

enum WalmartCoreDataStoreType: String {
    case sqlite, memory
    
    var type: String {
        switch self {
        case .sqlite:
            return NSSQLiteStoreType
        case .memory:
            return NSInMemoryStoreType
        }
    }
}
