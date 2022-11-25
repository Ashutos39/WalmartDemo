//
//  WalmartCoreDataWorkerAsyncOperationProtocol.swift
//
//  WalmartDemoProject
//
//  Created by Ashutos Sahoo on 24/11/22.
//

import CoreData

protocol WalmartCoreDataWorkerAsyncOperationProtocol {
    
    func get<T: NSManagedObject>(type: T.Type, withPredicateAttributes attributes: WalmartPredicateAttribute?, predicateType: NSCompoundPredicate.LogicalType, sortDescriptors: [NSSortDescriptor]?, fetchLimit: Int?, completion: WalmartCDWorkerCompletion<T>)
    func get<T: NSManagedObject>(type: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, fetchLimit: Int?, completion: WalmartCDWorkerCompletion<T>)
    func performAndSave(perform block: @escaping (_ context: NSManagedObjectContext) -> Void, completion: WalmartCDWorkerErrorCompletion)
    func delete(_ work: @escaping (_ context: NSManagedObjectContext) -> NSManagedObject, completion: WalmartCDWorkerErrorCompletion)
    func get<T: NSManagedObject>(type: T.Type, predicate: NSPredicate?, sortDescriptors: [NSSortDescriptor]?, fetchLimit: Int?, inContext: NSManagedObjectContext, completion: WalmartCDWorkerCompletion<T>)
    func delete(object: NSManagedObject, inContext context: NSManagedObjectContext, completion: WalmartCDWorkerErrorCompletion)
    func deleteAllAsync<T: NSManagedObject>(forType type: T.Type, completion: WalmartCDWorkerErrorCompletion)
    func deleteAllAsync<T: NSManagedObject>(forType type: T.Type, inContext context: NSManagedObjectContext, completion: WalmartCDWorkerErrorCompletion)
}

extension WalmartCoreDataWorkerAsyncOperationProtocol {
    
    func get<T: NSManagedObject>(type: T.Type, withPredicateAttributes attributes: WalmartPredicateAttribute? = nil, predicateType: NSCompoundPredicate.LogicalType = NSCompoundPredicate.LogicalType.and, sortDescriptors: [NSSortDescriptor]? = nil, fetchLimit: Int? = nil, completion: WalmartCDWorkerCompletion<T> = nil) {
        get(type: type, withPredicateAttributes: attributes, predicateType: predicateType, sortDescriptors: sortDescriptors, fetchLimit: fetchLimit, completion: completion)
    }
    
    func get<T: NSManagedObject>(type: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, fetchLimit: Int? = nil, completion: WalmartCDWorkerCompletion<T> = nil) {
        get(type: type, predicate: predicate, sortDescriptors: sortDescriptors, fetchLimit: fetchLimit, completion: completion)
    }
    
    func get<T: NSManagedObject>(type: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil,  fetchLimit: Int? = nil, inContext context: NSManagedObjectContext, completion: WalmartCDWorkerCompletion<T>) {
        get(type: type, predicate: predicate, sortDescriptors: sortDescriptors, fetchLimit: fetchLimit, inContext: context, completion: completion)
    }
}


