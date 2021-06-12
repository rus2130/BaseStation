import Foundation


class UIRegion: Identifiable, Equatable {
    static func == (lhs: UIRegion, rhs: UIRegion) -> Bool {
        return rhs.name.components(separatedBy: " ")[0] == lhs.name.components(separatedBy: " ")[0]
    }
    
    internal var id = UUID()
    
    var name = ""
    var stationsCount = "0"
    var localitiesCount = "0 н.пунктів"
    var rruCount = ""
    var dateOfIssue = "01.01.2021"
    
    init() {
        
    }
    
    init(regionStations: Region, newBases: Int?) {
        if regionStations.name == "Київ" {
            self.name = "Київ"
        } else {
            self.name = regionStations.name + " обл."
        }
        self.stationsCount = String(regionStations.stationsCount)
        
        if let newBase = newBases {
            self.stationsCount += " (\(newBase))"
        }
        
        if regionStations.localitiesCount == 1 { self.localitiesCount = "1" + " н. пункт" }
        else { self.localitiesCount = String(regionStations.localitiesCount) + " н. пунктів" }
        
        self.rruCount = getRRUString(rru: regionStations.rruCount)
        self.dateOfIssue = regionStations.dateOfIssue.toString
    }
    
    private func getRRUString(rru: [String: Int]) -> String {
        var rruString = ""
        
        for (rruName, count) in rru.sorted(by: {$0.1 > $1.1}) {
            rruString += " \(rruName): \(count) "
        }
        
        return rruString
    }
}
