//
//  NewsDetails+CoreDataProperties.swift
//  WalmartDemoProject
//
//  Created by Ashutos Sahoo on 25/11/22.
//
//

import Foundation
import CoreData


extension NewsDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsDetails> {
        return NSFetchRequest<NewsDetails>(entityName: "NewsDetails")
    }

    @NSManaged public var date: String?
    @NSManaged public var explanation: String?
    @NSManaged public var imageData: Data?
    @NSManaged public var title: String?

}

extension NewsDetails : Identifiable {

}
