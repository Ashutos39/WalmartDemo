//
//  WalmartCoreDataStack.swift
//
//  WalmartDemoProject
//
//  Created by Ashutos Sahoo on 24/11/22.
//

import CoreData


final class WalmartCoreDataStack: WalmartCoreDataStackProtocol {
    
    static let shared = WalmartCoreDataStack()
    
    private(set)var persistentContainer: NSPersistentContainer
    private(set) var config: WalmartCoreDataStackConfiguration
    
    var hasStore: Bool {
        !(persistentContainer.persistentStoreCoordinator.persistentStores.isEmpty)
    }
    
    init(withConfiguration config: WalmartCoreDataStackConfiguration = WalmartCoreDataStackConfiguration()) {
        
        //Creating manager object model
        self.config = config
        
        //Creating persistence container
        self.persistentContainer = NSPersistentContainer(name: config.storeName, managedObjectModel: NSManagedObjectModel.mergedModel(from: [Bundle.main])!)
    }
    
    //The class using this stack must call this method
    func loadStore(_ completion: WalmartPersistentStoreLoadCompletion) {
                
        //this will be helpful when application is using shared stack as well as other instances of the stack
        //store should be loaded once
        guard !hasStore else {
            return
        }
        //Creating persistence store description
        addStoreDescription()
        self.persistentContainer.loadPersistentStores { (description, error) in
            completion?(description, error)
        }
    }
    
    func deleteStore() -> WalmartVoidResult<Error> {
        
        guard let persistentStoreURL = storeURL else {
            return .failure(WalmartError.coreDataFailure(reason: .storeURLUnavailable))
        }
        do {
            try persistentContainer.persistentStoreCoordinator.destroyPersistentStore(at: persistentStoreURL, ofType: NSSQLiteStoreType, options: nil)
            return .success
        } catch  {
            return .failure(error)
        }
    }
    
    lazy var viewContext: NSManagedObjectContext = {
        let context:NSManagedObjectContext = self.persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        
        let context = self.persistentContainer.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        return context
    }()

    var storeURL: URL? {
        return self.persistentContainer.persistentStoreDescriptions.first?.url
    }
    
    func performBackgroundTaskOnNewContext(_ block: @escaping WalmartPerformTaskCompletion) {
        
        if let error = checkStore() {
            block(.failure(error))
            return
        }
        persistentContainer.performBackgroundTask { (context: NSManagedObjectContext) in
            block(.success(context))
        }
    }
        
    func performBackgroundTask(_ block: @escaping WalmartPerformTaskCompletion) {
        
        if let error = checkStore() {
            block(.failure(error))
            return
        }
        backgroundContext.perform {
            block(.success(self.backgroundContext))
        }
    }

    func performForegroundTask(_ block: @escaping WalmartPerformTaskCompletion) {
        
        if let error = checkStore() {
            block(.failure(error))
            return
        }
        viewContext.perform {
            block(.success(self.viewContext))
        }
    }
    
    func performSyncTask(_ block: WalmartPerformTaskCompletion) {
        
        if let error = checkStore() {
            block(.failure(error))
            return
        }
        viewContext.performAndWait {
            block(.success(self.viewContext))
        }
    }
}

private extension WalmartCoreDataStack {
    
    func addStoreDescription() {
        if let storeURL = self.storeURL {
            let storeDescription = NSPersistentStoreDescription(url: storeURL)
            storeDescription.type = config.storeType.type
            persistentContainer.persistentStoreDescriptions = [storeDescription]
        }
    }
}

//MARK: - Private -
private extension WalmartCoreDataStack {
  
    func checkStore() -> WalmartError? {
        guard !hasStore else {
            return nil
        }
        return WalmartError.coreDataFailure(reason: WalmartError.CoreDataFailureReason.storeUnavailable)
    }
}
