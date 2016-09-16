//
//  CoreDataProperties.swift
//  Grocery
//
//  Created by SimpuMind on 9/15/16.
//  Copyright © 2016 SimpuMind. All rights reserved.
//

import Foundation
import CoreData

extension Grocery {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Grocery> {
        return NSFetchRequest<Grocery>(entityName: "Grocery");
    }
    
    @NSManaged public var item: String?
    @NSManaged public var createdAt: NSDate?
}
