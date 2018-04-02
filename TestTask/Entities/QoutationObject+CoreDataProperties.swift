//
//  QoutationObject+CoreDataProperties.swift
//  
//
//  Created by Evgeny Plenkin on 29/03/2018.
//
//

import Foundation
import CoreData

extension QoutationObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<QoutationObject> {
        return NSFetchRequest<QoutationObject>(entityName: "QoutationObject")
    }

    @NSManaged public var ask: String?
    @NSManaged public var bid: String?
    @NSManaged public var spread: String?
    @NSManaged public var symbol: String?
    @NSManaged public var available: Bool?
    @NSManaged public var index: Int?
}
