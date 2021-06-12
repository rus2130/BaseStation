import Foundation

class Region: Identifiable, Equatable {
    static func == (lhs: Region, rhs: Region) -> Bool {
        lhs.name == rhs.name
    }
    
   
    internal let id = UUID()
    
    var name = ""
    var stationsCount = 0
    var localitiesCount = 0
    var rruCount = [String: Int]()
    var dateOfIssue = Date()
    
    
    init() {
        
    }
}
