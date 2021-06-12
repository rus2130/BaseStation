//
//  SearchView.swift
//  BaseStationNew
//
//  Created by Ruslan Duda on 06.04.2021.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var model: Model
    @State var filterText = ""
    @State var geometry: GeometryProxy
    var body: some View {
        VStack {
            TextField("Україна", text: $filterText)
                .onChange(of: filterText) {
                    model.loadComparisonLocalities(filter: $0)
                }
                .padding(7)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding()
    
            List(model.uiComparisonLocalities) { comparison in
                NavigationLink(destination: ComparisonView(model: model, region: comparison.region.components(separatedBy: " ")[0], locality:  comparison.locality, navBarTitle: "\(comparison.locality) (\(comparison.region[..<comparison.region.index(comparison.region.startIndex, offsetBy: 3)]).)")) {
                        HStack {
                            Text(comparison.locality)
                            Spacer()
                            Text(comparison.region)
                        }
                }
            }.id(UUID())
            .navigationBarTitle("Пошук")

            
        }.onAppear {
            model.uiComparisonProviders = []
        }
        
    }
}
