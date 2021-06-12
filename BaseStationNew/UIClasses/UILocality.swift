import Foundation


class UILocality: Identifiable, Equatable {
    static func == (lhs: UILocality, rhs: UILocality) -> Bool {
        return rhs.name.components(separatedBy: " ")[0] == lhs.name.components(separatedBy: " ")[0]
    }
    
    internal var id = UUID()
    
    var name = ""
    var stationsCount = ""
    var rruCount = ""
    var dateOfIssue = ""
    var region = ""
    var rruString = ""
    
    init() {}
    
    init(localityStations: Locality, newBases: Int?) {
        self.name = localityStations.name
        self.stationsCount = String(localityStations.stationsCount)
        
        if let newBase = newBases {
            self.stationsCount += " (\(newBase))"
        }
        
        self.region = localityStations.region
        self.dateOfIssue = localityStations.dateOfIssue.toString
        self.rruCount = getRRUString(rru: localityStations.rruCount)
    }
    
    private func getRRUString(rru: [String: Int]) -> String {
        var rruString = ""
        
        for (rruName, count) in rru.sorted(by: {$0.1 > $1.1}) {
            rruString += " \(rruName): \(count) "
        }
        
        return rruString
    }
    
}
