//
//  Trip+CoreDataProperties.swift
//  CoolBrakes
//
//  Created by James Ford on 10/27/21.
//
//

import Foundation
import CoreData


extension Trip {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Trip> {
        return NSFetchRequest<Trip>(entityName: "Trip")
    }

    @NSManaged public var idTrip: UUID?
    @NSManaged public var name: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var snapshots: NSOrderedSet?
    @NSManaged public var tripNotes: String?

    public var snapArray: [Snapshot] {
        return snapshots?.array as? [Snapshot] ?? []
        
    }
    
    public var formattedStartDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YY HH:mm"
        return dateFormatter.string(from: startDate ?? Date())
    }
    
}

// MARK: Generated accessors for snapshots
extension Trip {

    @objc(insertObject:inSnapshotsAtIndex:)
    @NSManaged public func insertIntoSnapshots(_ value: Snapshot, at idx: Int)

    @objc(removeObjectFromSnapshotsAtIndex:)
    @NSManaged public func removeFromSnapshots(at idx: Int)

    @objc(insertSnapshots:atIndexes:)
    @NSManaged public func insertIntoSnapshots(_ values: [Snapshot], at indexes: NSIndexSet)

    @objc(removeSnapshotsAtIndexes:)
    @NSManaged public func removeFromSnapshots(at indexes: NSIndexSet)

    @objc(replaceObjectInSnapshotsAtIndex:withObject:)
    @NSManaged public func replaceSnapshots(at idx: Int, with value: Snapshot)

    @objc(replaceSnapshotsAtIndexes:withSnapshots:)
    @NSManaged public func replaceSnapshots(at indexes: NSIndexSet, with values: [Snapshot])

    @objc(addSnapshotsObject:)
    @NSManaged public func addToSnapshots(_ value: Snapshot)

    @objc(removeSnapshotsObject:)
    @NSManaged public func removeFromSnapshots(_ value: Snapshot)

    @objc(addSnapshots:)
    @NSManaged public func addToSnapshots(_ values: NSOrderedSet)

    @objc(removeSnapshots:)
    @NSManaged public func removeFromSnapshots(_ values: NSOrderedSet)

}

extension Trip : Identifiable {

}
