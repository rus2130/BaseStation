//
//  BaseStationNewApp.swift
//  BaseStationNew
//
//  Created by Ruslan Duda on 02.04.2021.
//

import SwiftUI

@main
struct BaseStationNewApp: App {
    let model = Model()
    
    var body: some Scene {
        WindowGroup {
            ProvidersView(model: model)
            //RegionCell()
        }
    }
}
