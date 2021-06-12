//
//  UIComparisonLocalities.swift
//  BaseStationNew
//
//  Created by Ruslan Duda on 06.04.2021.
//

import Foundation

struct UIComparisonLocality: Identifiable {
    internal var id = String()
    var region = String()
    var locality = String()
    
    init(region: String, locality: String) {
        self.id = region + locality
        self.locality = locality
        if region == "Київ" {
            self.region = "Київ"
        } else {
            self.region = region + " обл."
        }
    }
}
