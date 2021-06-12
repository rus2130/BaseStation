//
//  UIComparisonProvider.swift
//  BaseStationNew
//
//  Created by Ruslan Duda on 05.04.2021.
//

import Foundation
import SwiftUI

class UIComparisonProvider: Identifiable, Equatable {
    static func == (lhs: UIComparisonProvider, rhs: UIComparisonProvider) -> Bool {
        return lhs.provider == rhs.provider
    }
    
    internal var id = UUID()
    public var color: Color = .white
    public var provider = "Kyivstar"
    public var stationsCount = "xxxxx"
    public var lteBasesCount = "LTE: "
    public var lte900BasesCount = "900: "
    public var lte1800BasesCount = "1800: "
    public var lte2600BasesCount = "2600: "
    
    public var gsmBasesCount = "GSM: "
    public var gsm900BasesCount = "900: "
    public var gsm1800BasesCount = "1800: "
    
    public var umtsBasesCount = "UMTS: "
    public var umts2100BasesCount = "2100: "
    
    init() {}
    
    init(comparisonStations: ComparisonProvider) {
        self.stationsCount = String(comparisonStations.stationsCount)
        
        self.provider = comparisonStations.provider
        self.color = getColor(provider: comparisonStations.provider)
        
        self.lteBasesCount = "LTE: " + String(comparisonStations.lteBasesCount)
        self.lte900BasesCount = "900: " + String(comparisonStations.lte900BasesCount)
        self.lte1800BasesCount = "1800: " + String(comparisonStations.lte1800BasesCount)
        self.lte2600BasesCount = "2600: " + String(comparisonStations.lte2600BasesCount)
        
        self.umtsBasesCount = "UMTS: " + String(comparisonStations.umtsBasesCount)
        self.umts2100BasesCount = "2100: " + String(comparisonStations.umts2100BasesCount)
        
        self.gsmBasesCount = "GSM: " + String(comparisonStations.gsmBasesCount)
        self.gsm900BasesCount = "900: " + String(comparisonStations.gsm900BasesCount)
        self.gsm1800BasesCount = "1800: " + String(comparisonStations.gsm1800BasesCount)
        
        
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
            return .white
        }
    }
}
