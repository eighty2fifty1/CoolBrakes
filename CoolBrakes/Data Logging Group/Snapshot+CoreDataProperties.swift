//
//  Snapshot+CoreDataProperties.swift
//  CoolBrakes
//
//  Created by James Ford on 10/27/21.
//
//

import Foundation
import CoreData


extension Snapshot {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Snapshot> {
        return NSFetchRequest<Snapshot>(entityName: "Snapshot")
    }

    @NSManaged public var idSnap: UUID?
    @NSManaged public var posit: Int16
    @NSManaged public var sensorTemp: Int16
    @NSManaged public var timestamp: Date?
    @NSManaged public var speed: Double
    @NSManaged public var altitude: Double
    @NSManaged public var trip: Trip?

}
