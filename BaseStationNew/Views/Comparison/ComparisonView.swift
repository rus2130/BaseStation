//
//  ComparisonView.swift
//  BaseStationNew
//
//  Created by Ruslan Duda on 05.04.2021.
//

import SwiftUI

struct ComparisonView: View {
    @ObservedObject var model: Model
    @State var geometry: GeometryProxy?
    @State var region: String? = nil
    @State var locality: String? = nil
    @State var navBarTitle = "Україна"
    
    var body: some View {
        GeometryReader { geometry1 in
            
        
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .center, spacing: 8) {
                NavigationLink(destination: SearchView(model: model, geometry: geometry1)) {
                ZStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: 8).foregroundColor(Color(.systemGray6)).frame(width: geometry1.size.width - 16, height: 40, alignment: .center)
                    HStack(alignment: .center) {
                        Spacer().frame(width: 20)
                        Text("Пошук")
                        Spacer()
                        Text("")
                        Spacer().frame(width: 20)
                    }
                }
                }.simultaneousGesture(TapGesture().onEnded{
                    model.loadComparisonLocalities()
                })
                //
                ForEach(model.uiComparisonProviders) { uiComparisonProvider in
                    ComparisonCell(comparisonProvider: uiComparisonProvider, color: uiComparisonProvider.color, width: geometry1.size.width, height: geometry1.size.height)
                    
                }
            }.navigationBarTitle(navBarTitle)
            
        }.onAppear {
            DispatchQueue.global(qos: .userInteractive).async {
                self.model.loadComparisonProviders(region: region, locality: locality)
            }
        }
    }
    }
    
}
