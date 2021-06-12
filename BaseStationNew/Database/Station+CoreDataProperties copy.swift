import Foundation
import CoreData


extension Station {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Station> {
        return NSFetchRequest<Station>(entityName: "Station")
    }

    @NSManaged public var date: Date
    @NSManaged public var dateOfIssue: String
    @NSManaged public var freq: String
    @NSManaged public var locality: String
    @NSManaged public var operatingPermit: String
    @NSManaged public var region: String
    @NSManaged public var rru: String
    @NSManaged public var technology: String
    @NSManaged public var uniqueID: String
}
