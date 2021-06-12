import Foundation
import CoreData

extension String {
    var toDate: Date {
        let date = DateFormatter.standardDateFormatter.date(from: self) ?? Date().advanced(by: 5)
        return date
    }
}

extension Date {
    var toString: String {
        return(DateFormatter.standardDateFormatter.string(from: self))
    }
}

extension DateFormatter {
    public static let standardDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd'.'MM'.'yyyy'"
        return dateFormatter
    }()
}




public extension NSManagedObject {
    convenience init(context: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: context)!
        self.init(entity: entity, insertInto: context)
    }
    
}

