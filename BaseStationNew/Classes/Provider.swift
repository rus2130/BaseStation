import Foundation


class Provider: Identifiable, CustomStringConvertible, Equatable {
    static func == (lhs: Provider, rhs: Provider) -> Bool {
        lhs.id == rhs.id
    }
    
    var description: String {
        return "\(self.provider)\n" +
            "Regions: \(self.regionsCount)\n" +
            "Localities: \(self.localitiesCount)\n" +
            "Stations: \(self.stationsCount)\n" +
            "DateOfIssue: \(self.dateOfIssue.toString)\n" +
            "Rru: \(self.rruCount)\n"
    }
    
    var id = UUID()
    
    var provider = "Invalid"
    var regionsCount = 0
    var stationsCount = 0
    var localitiesCount = 0
    var rruCount = [String: Int]()
    var dateOfIssue = Date()

}
