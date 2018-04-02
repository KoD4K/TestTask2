//
//  QoutationObject+CoreDataClass.swift
//  
//
//  Created by Evgeny Plenkin on 29/03/2018.
//
//

import Foundation
import CoreData

@objc(QoutationObject)
public class QoutationObject: NSManagedObject {
    convenience init() {
        self.init(entity: CoreDataManager.instance.entityForName("QoutationObject"), insertIntoManagedObjectContext: CoreDataManager.instance.managedObjectContext)
    }
}
