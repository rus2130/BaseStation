import Foundation
import CoreData

class ParsedArrayToCoreData {
   
    static var lock = NSLock()
    
    public func preparationBeforeSaving(parsedArray: [[String]], context: NSManagedObjectContext) {
        var stations = [Station]()
        
        for rowData in parsedArray {
            let station = Station(context: context)
        
            station.operatingPermit = rowData[0]
            station.date = rowData[1].toDate
            station.dateOfIssue = rowData[1]
            station.region = rowData[3]
            station.locality = rowData[4]
            station.rru = bsNames[rowData[5]] ?? rowData[5]
            let values = rowData[7].components(separatedBy: ",")
            if rowData[9] != "UMTS" {
            station.freq = freqOps[values[0]] ?? freqOps[values[0].components(separatedBy: "-")[0]] ?? freqOps[values[0].components(separatedBy: ".")[0]] ?? "Invalid"
            } else {
                station.freq = freqOps[rowData[7]] ?? freqOps[rowData[7].components(separatedBy: "-")[0]] ?? freqOps[rowData[7].components(separatedBy: ".")[0]] ?? "Invalid"
            }
            station.technology = rowData[9]
            
            station.uniqueID = station.operatingPermit + station.dateOfIssue + station.region + station.locality + station.technology
            stations.append(station)
        }
       // saveContext(context: context)
    }
    
    private func saveContext(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
                print("Not unique")
            }
        }
    }
  
}
