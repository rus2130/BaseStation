//
//  LocationCell.swift
//  BaseStationNew
//
//  Created by Ruslan Duda on 05.04.2021.
//

import SwiftUI

struct LocalityCell: View {
    @State var locality: UILocality
    @State var color: Color
    @State var width: CGFloat
    @State var height: CGFloat
    
    
    var body: some View {
        
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 8).foregroundColor(color).frame(width: width - 16, height: height / 5.0 - 5)
                //.shadow(color: .gray, radius: 2, x: 1, y: 2)
            VStack(spacing: 15) {
                Text(locality.name)
                HStack {
                    Text(locality.stationsCount)
                    Spacer().frame(width: 150)
                    Text(locality.dateOfIssue)
                        
                }
                Text(locality.rruCount)
                    .frame(width: width - 55, height: nil, alignment: .center)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.1)
            }.foregroundColor(.white)
            
        }
    }

}
  


