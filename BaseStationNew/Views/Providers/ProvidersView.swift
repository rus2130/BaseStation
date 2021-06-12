//
//  ContentView.swift
//  BaseStationNew
//
//  Created by Ruslan Duda on 01.04.2021.
//

import SwiftUI
import CoreData


struct ProvidersView: View {
    @State var selectedProvider = "Invalid"
    @State var currentTechnologyIndex = 0
    @State var technologies = [Technologies.lte, Technologies.umts, Technologies.gsm, Technologies.all]
    @State var isActionSheet = false
    
    @ObservedObject var model = Model()
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                ScrollView(.vertical, showsIndicators: false) {
                    Picker("Technology", selection: $currentTechnologyIndex, content: {
                        Text("LTE").tag(0)
                        Text("UMTS").tag(1)
                        Text("GSM").tag(2)
                        Text("ALL").tag(3)
                    })
                    .pickerStyle(SegmentedPickerStyle()) // <1>
                    .padding(.horizontal, 8)
                    .padding(.bottom, 4)
                    .onChange(of: currentTechnologyIndex) { tag in
                        switch currentTechnologyIndex {
                        case 0:
                            let generator = UIImpactFeedbackGenerator(style: .light)
                            generator.impactOccurred()
                        case 1:
                            let generator = UISelectionFeedbackGenerator()
                            generator.selectionChanged()
                        case 2:
                            let generator = UIImpactFeedbackGenerator(style: .heavy)
                            generator.impactOccurred()
                            
                        default:
                            let generator = UINotificationFeedbackGenerator()
                                      generator.notificationOccurred(.success)
                        }
                        
                        model.technologyFilter(technology: technologies[tag])
                    }
                    
                    VStack(alignment: .center, spacing: 8) {
                        ForEach(model.uiProviders.sorted(by: { Int($0.stationsCount.components(separatedBy: " ")[0]) ?? 0 > Int($1.stationsCount.components(separatedBy: " ")[0]) ?? 0 })) { provider in
                            NavigationLink(destination: RegionsView(model: model, color: provider.color, provider: provider.provider, geometry: geometry)) {
                             ProviderCell(provider: provider, width: geometry.size.width, height: geometry.size.height)
                            }.animation(.spring(), value: model.uiProviders)
                            .simultaneousGesture(TapGesture().onEnded{
                                model.uiBarTitleRegions = provider.provider + " " + technologies[currentTechnologyIndex].rawValue
                                model.loadRegions(provider: provider.provider)
                            })
                        }
                    }
                    .navigationBarItems(leading: NavigationLink(destination: ComparisonView(model: model, geometry: geometry)) {
                        Text("Порівняння")
                    }
                    , trailing: showActionSheet())
                    .navigationBarTitle(Text(model.uiBarTitle))
                }
               
            }
            
        }
        
    }
    private func showActionSheet() -> some View {
        return Button(action: {
            self.isActionSheet = true
        }, label: {
            Text("Фільтр")
        }).actionSheet(isPresented: $isActionSheet, content: {test()})
    }
    
    private func test() -> ActionSheet {
        switch currentTechnologyIndex {
        case 0: return ActionSheet(title: Text("Фільтр"),buttons: [.cancel(), .default(Text("LTE")) {
            model.technologyFilter(technology: .lte)
        }, .default(Text("LTE 1800")) {
            model.technologyFilter(technology: .lte1800)
        }, .default(Text("LTE 2600")) {
            model.technologyFilter(technology: .lte2600)
        }, .default(Text("LTE 900")) {
            model.technologyFilter(technology: .lte900)
        }])
        case 1: return ActionSheet(title: Text("Фільтр"),buttons: [.cancel(), .default(Text("UMTS")) {
            model.technologyFilter(technology: .umts)
        }])
        case 2: return ActionSheet(title: Text("Фільтр"),buttons: [.cancel(), .default(Text("GSM")) {
            model.technologyFilter(technology: .gsm)
        }, .default(Text("GSM 1800")) {
            model.technologyFilter(technology: .gsm1800)
        }, .default(Text("GSM 900")) {
            model.technologyFilter(technology: .gsm900)
        }])
        default:
            return ActionSheet(title: Text("Фільтр"),buttons: [.cancel()])
        }
    }
//    fileprivate func comparisonButton() {
//
//    }
    
}



