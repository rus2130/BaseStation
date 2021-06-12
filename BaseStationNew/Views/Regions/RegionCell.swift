//
//  RegionCell.swift
//  BaseStationNew
//
//  Created by Ruslan Duda on 03.04.2021.
//

import SwiftUI

struct RegionCell: View {
    @State var region: UIRegion
    @State var color: Color
    @State var width: CGFloat
    @State var height: CGFloat
    
    
    var body: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 8).foregroundColor(color).frame(width: width - 16, height: height / 5.0 - 5)
               // .shadow(color: .gray, radius: 2, x: 1, y: 2)
            VStack(spacing: 5) {
                Text(region.name)
                
                HStack {
                    VStack {
                        Text(region.stationsCount)
                        Text(region.localitiesCount)
                    }
                    Spacer().frame(width: 100)
                    Text(region.dateOfIssue)
                }
                Text(region.rruCount)
                    .frame(width: width - 55, height: nil, alignment: .center)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.1)
            }.foregroundColor(.white)
            
        }
    }

}



