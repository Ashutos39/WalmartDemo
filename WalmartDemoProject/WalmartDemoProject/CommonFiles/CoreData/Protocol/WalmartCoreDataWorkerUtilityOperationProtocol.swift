//
//  WalmartCoreDataWorkerUtilityOperation.swift
//
//  WalmartDemoProject
//
//  Created by Ashutos Sahoo on 24/11/22.
//

import CoreData

protocol WalmartCoreDataWorkerUtilityOperationProtocol {
    
    var backgroundContext: NSManagedObjectContext? { get }
    var mainContext: NSManagedObjectContext? { get }
    var persistentContainer: NSPersistentContainer? { get }
    @discardableResult
    func getOrCreateSingle<T: NSManagedObject>(type: T.Type, withPredicateAttributes attributes: WalmartPredicateAttribute?, predicateType predicate: NSCompoundPredicate.LogicalType, from context: NSManagedObjectContext) -> T
    func createPredicate(with attributes: WalmartPredicateAttribute, predicateType: NSCompoundPredicate.LogicalType) -> NSPredicate
    func save(inContext context: NSManagedObjectContext) -> Result<Any?, Error>
    func clearDatabase() -> WalmartVoidResult<Error>
}

extension WalmartCoreDataWorkerUtilityOperationProtocol {
    @discardableResult
    func getOrCreateSingle<T: NSManagedObject>(type: T.Type, withPredicateAttributes attributes: WalmartPredicateAttribute? = nil, predicateType predicate: NSCompoundPredicate.LogicalType = NSCompoundPredicate.LogicalType.and, from context: NSManagedObjectContext) -> T {
        return getOrCreateSingle(type: type, withPredicateAttributes: attributes, predicateType: predicate, from: context)
    }
    
    func createPredicate(with attributes: WalmartPredicateAttribute,
                         predicateType: NSCompoundPredicate.LogicalType = NSCompoundPredicate.LogicalType.and) -> NSPredicate {
        return createPredicate(with: attributes, predicateType: predicateType)
    }
}


