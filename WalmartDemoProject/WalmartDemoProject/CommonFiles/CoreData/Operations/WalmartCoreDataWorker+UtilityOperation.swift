//
//  WalmartCoreDataWorker+UtilityOperation.swift
//
//  WalmartDemoProject
//
//  Created by Ashutos Sahoo on 24/11/22.
//

import CoreData

extension WalmartCoreDataWorker: WalmartCoreDataWorkerUtilityOperationProtocol {
  
    var persistentContainer: NSPersistentContainer? {
        guard coreDataStack.hasStore else {
            return nil
        }
        return coreDataStack.persistentContainer
    }
    
    var backgroundContext: NSManagedObjectContext? {
        guard coreDataStack.hasStore else {
            return nil
        }
        return coreDataStack.backgroundContext
    }
    
    var mainContext: NSManagedObjectContext? {
        guard coreDataStack.hasStore else {
            return nil
        }
        return coreDataStack.viewContext
    }
    
    //it doesn't has "coreDataStack.hasStore" condition because it needs a context to work and the context exposed from this WalmartCoreDataWorker has that condtion, so if this class is exposing new context always check for that "coreDataStack.hasStore" condition
    @discardableResult
    func getOrCreateSingle<T: NSManagedObject>(type: T.Type, withPredicateAttributes attributes: WalmartPredicateAttribute? = nil, predicateType predicate: NSCompoundPredicate.LogicalType = NSCompoundPredicate.LogicalType.and, from context: NSManagedObjectContext) -> T {
        
        guard let attributes = attributes else {
            let result = insertNew(type: type, in: context)
            return result
        }
        let result = single(forType: type, withPredicateAttributes: attributes, predicateType: predicate, from: context) ?? insertNew(type: type, in: context)
        for (key,value) in attributes {
            result.setValue(value, forKeyPath: key)
        }
        return result
    }
        
    func createFetchRequest<T: NSManagedObject>(forType type: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, fetchLimit limit: Int? = nil, returnsObjectsAsFaults objectsAsFaults:Bool = true) -> NSFetchRequest<T> {
        
        let request = NSFetchRequest<T>(entityName: entityName(forType: type))
        request.returnsObjectsAsFaults = objectsAsFaults
        if let limit = limit {
            request.fetchLimit = limit
        }
        if let predicate = predicate {
            request.predicate = predicate
        }
        if let sortDescriptors = sortDescriptors {
            request.sortDescriptors = sortDescriptors
        }
        return request
    }
    
    func createPredicate(with attributes: WalmartPredicateAttribute,
                         predicateType: NSCompoundPredicate.LogicalType = NSCompoundPredicate.LogicalType.and) -> NSPredicate {
        
        var predicates: [NSPredicate] = []
        for (attribute, value) in attributes {
            predicates.append(NSPredicate(format: "%K = %@", argumentArray: [attribute, value]))
        }
        let compoundPredicate = NSCompoundPredicate(type: predicateType, subpredicates: predicates)
        return compoundPredicate
    }
    
    func save(inContext context: NSManagedObjectContext) -> Result<Any?, Error> {
       
        if let error = checkForStoreAvailablity() {
            return .failure(error)
        }
        do {
            try context.save()
            return .success(nil)
        } catch {
            return .failure(error)
        }
    }
    
    func clearDatabase() -> WalmartVoidResult<Error> {
        return coreDataStack.deleteStore()
    }
}
