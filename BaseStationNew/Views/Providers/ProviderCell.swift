import SwiftUI


struct ProviderCell: View {
    @State var provider: UIProvider
    @State var width: CGFloat
    @State var height: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8).foregroundColor(provider.color).frame(width: width - 16, height: height / 3.0 - 23.5)
                //.shadow(color: .gray, radius: 5, x: 2, y: 3)
            VStack {
                HStack {
                    VStack {
                        Text(provider.provider)
                        Spacer().frame(height: 10)
                        Text("Покриття:")
                        Text(provider.regionsCount)
                        Text(provider.localitiesCount)
                    }
                    Spacer().frame(width: 100)
                    VStack {
                        Text(provider.stationsCount)
                        Spacer().frame(height: 5)
                        Text("Оновлено:")
                        Text(provider.dateOfIssue)
                    }
                }
                Spacer().frame(height: 20)
                Text(provider.rruCount)
                    .frame(width: width - 70, height: nil, alignment: .center)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.1)
            }
        }.foregroundColor(.white)
    }
   
}
