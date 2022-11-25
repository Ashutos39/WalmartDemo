//
//  WalmartCoreDataWorker+AsyncOperation.swift
//
//  WalmartDemoProject
//
//  Created by Ashutos Sahoo on 24/11/22.
//

import CoreData

extension WalmartCoreDataWorker: WalmartCoreDataWorkerAsyncOperationProtocol {
    
    func get<T: NSManagedObject>(type: T.Type, withPredicateAttributes attributes: WalmartPredicateAttribute? = nil, predicateType: NSCompoundPredicate.LogicalType = NSCompoundPredicate.LogicalType.and, sortDescriptors: [NSSortDescriptor]? = nil, fetchLimit: Int? = nil, completion: WalmartCDWorkerCompletion<T> = nil) {
        
        var predicate: NSPredicate? = nil
        if let attributes = attributes {
            predicate = createPredicate(with: attributes, predicateType: predicateType)
        }
        coreDataStack.performBackgroundTask { (result: WalmartPerformTaskResult) in
            
            switch result {
            case .success(let context):
                return self.get(type: type, predicate: predicate, sortDescriptors: sortDescriptors, fetchLimit: fetchLimit,  inContext: context, completion: completion)
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    func get<T: NSManagedObject>(type: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, fetchLimit: Int? = nil,  completion: WalmartCDWorkerCompletion<T> = nil) {
        
        coreDataStack.performBackgroundTask { (result: WalmartPerformTaskResult) in
            
            switch result {
            case .success(let context):
                return self.get(type: type, predicate: predicate, sortDescriptors: sortDescriptors, fetchLimit: fetchLimit,  inContext: context, completion: completion)
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    func get<T: NSManagedObject>(type: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, fetchLimit: Int?, inContext context: NSManagedObjectContext, completion: WalmartCDWorkerCompletion<T>) {
        
        if let error = checkForStoreAvailablity() {
            completion?(.failure(error))
            return
        }
        context.perform {
            
            let fetchRequest = self.createFetchRequest(forType: type, predicate: predicate, sortDescriptors: sortDescriptors, fetchLimit: fetchLimit)
            do {
                let result = try context.fetch(fetchRequest)
                completion?(.success(result))
            } catch {
                completion?(.failure(error))
            }
        }
    }
        
    func performAndSave(perform block: @escaping (_ context: NSManagedObjectContext) -> Void, completion: WalmartCDWorkerErrorCompletion){
        
        coreDataStack.performBackgroundTask { (taskResult: WalmartPerformTaskResult) in
            
            switch taskResult {
            case .success(let context):
                block(context)
                let result = self.save(inContext: context)
                switch result {
                case .success(_):
                    completion?(WalmartVoidResult.success)
                case .failure(let error):
                    completion?(.failure(error))
                }
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    func delete(_ work: @escaping (_ context: NSManagedObjectContext) -> NSManagedObject, completion: WalmartCDWorkerErrorCompletion = nil) {
        
        coreDataStack.performBackgroundTaskOnNewContext { (taskResult: WalmartPerformTaskResult) in
            
            switch taskResult {
            case .success(let context):
            self.delete(object: work(context), inContext: context, completion: completion)
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    func delete(object: NSManagedObject, inContext context: NSManagedObjectContext, completion: WalmartCDWorkerErrorCompletion = nil) {
        
        coreDataStack.performBackgroundTask { (taskResult: WalmartPerformTaskResult) in
            
            switch taskResult {
            case .success(_):
                context.delete(object)
                let result = self.save(inContext: context)
                switch result {
                case .success(_):
                    completion?(WalmartVoidResult.success)
                case .failure(let error):
                    completion?(.failure(error))
                }
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    func deleteAllAsync<T: NSManagedObject>(forType type: T.Type, completion: WalmartCDWorkerErrorCompletion) {
        
        coreDataStack.performBackgroundTask { (taskResult: WalmartPerformTaskResult) in
            
            switch taskResult {
            case .success(let context):
                self.perfromDeleteAll(forType: type, inContext: context, completion: completion)
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    func deleteAllAsync<T: NSManagedObject>(forType type: T.Type, inContext context: NSManagedObjectContext, completion: WalmartCDWorkerErrorCompletion) {
        
        if let error = checkForStoreAvailablity() {
            completion?(.failure(error))
            return
        }
        context.perform {
            self.perfromDeleteAll(forType: type, inContext: context, completion: completion)
        }
    }
}

private extension WalmartCoreDataWorker {
    
    func perfromDeleteAll<T: NSManagedObject>(forType type: T.Type, inContext context: NSManagedObjectContext, completion: WalmartCDWorkerErrorCompletion) {
        
        let result = self.all(forType: type, in: context)
        switch result {
        case .success(let objects):
            objects.forEach {
                context.delete($0)
            }
            let result = self.save(inContext: context)
            switch result {
            case .success(_):
                completion?(WalmartVoidResult.success)
            case .failure(let error):
                completion?(WalmartVoidResult.failure(error))
                debugPrint("error in deleteAll", error.localizedDescription)
            }
            
        case .failure(let error):
            completion?(WalmartVoidResult.failure(error))
            debugPrint("error in deleteAll", error.localizedDescription)
        }
    }
}
