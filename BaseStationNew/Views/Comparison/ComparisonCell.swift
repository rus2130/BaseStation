//
//  ComparisonCell.swift
//  BaseStationNew
//
//  Created by Ruslan Duda on 05.04.2021.
//

import SwiftUI

struct ComparisonCell: View {
    @State var comparisonProvider: UIComparisonProvider
    @State var color: Color
    @State var width: CGFloat
    @State var height: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10).fill(color).frame(width: width - 16, height: height / 2.5)
            VStack {
                HStack {
                    VStack {
                        Text(comparisonProvider.provider)
                        Spacer().frame(height: 20)
                        Text(comparisonProvider.lteBasesCount)
                        Text(comparisonProvider.lte900BasesCount)
                        Text(comparisonProvider.lte1800BasesCount)
                        Text(comparisonProvider.lte2600BasesCount)
                    }
                    Spacer().frame(width: 100)
                    VStack {
                        Text(comparisonProvider.stationsCount)
                        Spacer().frame(height: 20)
                        Text(comparisonProvider.umtsBasesCount)
                        Text(comparisonProvider.umts2100BasesCount)
                        Text("")
                        Text("")
                    }
                }
                VStack {
                    Text(comparisonProvider.gsmBasesCount)
                    Text(comparisonProvider.gsm900BasesCount)
                    Text(comparisonProvider.gsm1800BasesCount)
                }
            }
        }.foregroundColor(.white)
        
    }
}

