import Foundation


class Locality: Equatable, Identifiable {
    static func == (lhs: Locality, rhs: Locality) -> Bool {
        return lhs.region == rhs.region && lhs.name == rhs.name
    }
    
    
    internal let id = UUID()
    var name = ""
    var stationsCount = 0
    var rruCount = [String: Int]()
    var dateOfIssue = Date()
    var region = ""

    
    init() {
        
    }
}
