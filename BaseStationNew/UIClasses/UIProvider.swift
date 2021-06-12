import Foundation
import SwiftUI


class UIProvider: Identifiable, Equatable, CustomStringConvertible {
    var description: String {
        return "\(self.provider)\n" +
            "Regions: \(self.regionsCount)\n" +
            "Localities: \(self.localitiesCount)\n" +
            "Stations: \(self.stationsCount)\n" +
            "DateOfIssue: \(self.dateOfIssue)\n" +
            "Rru: \(self.rruCount)\n"
    }
    
        static func == (lhs: UIProvider, rhs: UIProvider) -> Bool {
            return lhs.provider == rhs.provider
        }
        
        internal var id = UUID()
        
        var provider = "Invalid"
        var regionsCount = ""
        var stationsCount = ""
        var localitiesCount = ""
        var rruCount = ""
        var dateOfIssue = ""
        var color = Color.white
    
    init() {
        
    }
    
    init(providerStations: Provider, newBases: Int?) {
        self.provider = providerStations.provider
        self.color = getColor(provider: provider)
        self.regionsCount = String(providerStations.regionsCount) + " регіонів"
        self.stationsCount = String(providerStations.stationsCount)
        
        if let newBase = newBases {
            self.stationsCount += " (\(newBase))"
        }
        
        
        if providerStations.localitiesCount == 1 {
            self.localitiesCount = String(providerStations.localitiesCount) + " н. пункт"
        } else {
            self.localitiesCount = String(providerStations.localitiesCount) + " н. пунктів"
        }
        
        self.rruCount = getRRUString(rru: providerStations.rruCount)
        self.dateOfIssue = providerStations.dateOfIssue.toString
        
        
    }
    
    
    private func getRRUString(rru: [String: Int]) -> String {
        var rruString = ""
        
        for (rruName, count) in rru.sorted(by: {$0.1 > $1.1}) {
            rruString += " \(rruName): \(count) "
        }
        
        return rruString
    }
    
    private func getColor(provider: String) -> Color {
        let providerEnum = Providers(rawValue: provider) ?? .invalid
        
        switch providerEnum {
        case .kyivstar:
            return Color(red: 34 / 255, green: 159 / 255, blue: 255 / 255)
        case .vodafone:
            return Color(red: 230 / 255, green: 0, blue: 0)
        case .lifecell:
            return Color(red: 20 / 255, green: 74 / 255, blue: 155 / 255)
        default:
            return .black
        }
    }
}
