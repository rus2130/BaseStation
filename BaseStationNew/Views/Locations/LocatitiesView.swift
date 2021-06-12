//
//  LocationsView.swift
//  BaseStationNew
//
//  Created by Ruslan Duda on 05.04.2021.
//

import SwiftUI

struct LocalitiesView: View {
    @ObservedObject var model: Model
    @State var color: Color
    @State var provider: String
    @State var region: String
    @State var geometry: GeometryProxy
    @State var isActionSheet = false
    
    var body: some View {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center, spacing: 8) {
                    ForEach(model.uiLocalities) { locality in
                        NavigationLink(destination: ComparisonView(model: model, region: region.components(separatedBy: " ")[0], locality:  locality.name, navBarTitle: "\(locality.name) (\(region[..<region.index(region.startIndex, offsetBy: 3)]).)")) {
                         LocalityCell(locality: locality, color: color, width: geometry.size.width, height: geometry.size.height)
                        }
                    }.animation(.spring(response: 0.5, dampingFraction: 0.9, blendDuration: 0.1), value: model.uiLocalities)
                    .navigationBarItems(trailing: showActionSheet())
                }
            
            }.navigationBarTitle(Text(model.uiBarTitleLocalities))
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
            model.sortLocalities(type: .abc)
        }, .default(Text("За кількістю бс")) {
            model.sortLocalities(type: .bsCount)
        }, .default(Text("За датою")) {
            model.sortLocalities(type: .dateOfIssue)
        }])
    }
}

