//
//  RegionsView.swift
//  BaseStationNew
//
//  Created by Ruslan Duda on 03.04.2021.
//

import SwiftUI

struct RegionsView: View {
    @ObservedObject var model: Model
    @State var color: Color
    @State var provider: String
    //@State var currentProvider: String
    @State var geometry: GeometryProxy
    @State var isActionSheet = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .center, spacing: 8) {
                ForEach(model.uiRegions) { region in
                    NavigationLink(destination: LocalitiesView(model: model, color: color, provider: provider, region: region.name, geometry: geometry)) {
                        RegionCell(region: region, color: color, width: geometry.size.width, height: geometry.size.height)
                    }.simultaneousGesture(TapGesture().onEnded{
                        model.uiBarTitleLocalities = region.name.components(separatedBy: " ")[0]
                        model.loadLocalities(provider: provider, region: region.name)
                    })
                }.animation(.spring(response: 0.5, dampingFraction: 0.9, blendDuration: 0.1), value: model.uiRegions)
                .navigationBarItems(trailing: showActionSheet())
            }.navigationBarTitle(model.uiBarTitleRegions)
            
        }
    }
    private func showActionSheet() -> some View {
        return Button(action: {
            self.isActionSheet = true
        }, label: {
            Text("Сортування")
        }).actionSheet(isPresented: $isActionSheet, content: { test() })
    }
    
    private func test() -> ActionSheet {
        ActionSheet(title: Text("Фільтр"),buttons: [.cancel(), .default(Text("За назвою")) {
            model.sortRegions(type: .abc)
        }, .default(Text("За кількістю бс")) {
            model.sortRegions(type: .bsCount)
        }, .default(Text("За датою")) {
            model.sortRegions(type: .dateOfIssue)
        }])
    }
}

