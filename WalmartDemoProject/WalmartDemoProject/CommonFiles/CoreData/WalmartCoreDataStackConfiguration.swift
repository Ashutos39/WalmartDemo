//
//  WalmartCoreDataStackConfiguration.swift
//
//  WalmartDemoProject
//
//  Created by Ashutos Sahoo on 24/11/22.
//

import Foundation


struct WalmartCoreDataStackConfiguration {
    
    var storeType: WalmartCoreDataStoreType = .sqlite
    var storeName: String = Bundle.main.appName
}

extension Bundle {
    var appName: String {
        
        let defaultValue = "Walmart"
        guard let infoDict = Bundle.main.infoDictionary else { return defaultValue }
        if let displayName = infoDict["CFBundleDisplayName"] as? String {
            return displayName
        }
        return infoDict["CFBundleName"] as? String ?? defaultValue
    }
}
