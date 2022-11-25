//
//  WalmartCoreDataStackProtocol.swift
//  WalmartDemoProject
//
//  Created by Ashutos Sahoo on 24/11/22.
//

import CoreData

typealias WalmartPersistentStoreLoadCompletion = (((NSPersistentStoreDescription?, Error?) -> Void)?)
typealias WalmartManagedObjectContext = NSManagedObjectContext
typealias WalmartManagedObject = NSManagedObject
typealias WalmartPerformTaskResult = (Result<NSManagedObjectContext, WalmartError>)
typealias WalmartPerformTaskCompletion = (WalmartPerformTaskResult) -> Void

protocol WalmartCoreDataStackProtocol {
    
    init?(withConfiguration config: WalmartCoreDataStackConfiguration)
    var config: WalmartCoreDataStackConfiguration { get }
    var hasStore: Bool { get }
    var persistentContainer: NSPersistentContainer {get}
    var viewContext: NSManagedObjectContext {get}
    var backgroundContext: NSManagedObjectContext {get}
    var storeURL: URL? {get}
    func loadStore(_ completion: WalmartPersistentStoreLoadCompletion)
    func deleteStore() -> WalmartVoidResult<Error>
    func performBackgroundTask(_ block: @escaping WalmartPerformTaskCompletion)
    func performBackgroundTaskOnNewContext(_ block: @escaping WalmartPerformTaskCompletion)
    func performForegroundTask(_ block: @escaping WalmartPerformTaskCompletion)
    func performSyncTask(_ block: WalmartPerformTaskCompletion)
}

extension WalmartCoreDataStackProtocol {
  var printableStoreURL: String {
    return self.persistentContainer.persistentStoreDescriptions.first?.url?.absoluteString.removingPercentEncoding ?? ""
  }
}
