//
//  CardView.swift
//  PollenAppSwiftUI
//
//  Created by Sabri Sönmez on 2/14/21.
//

import SwiftUI


struct PollenCardView: View {
    
    @State var isLinkActive = false
    @Environment (\.colorScheme) var colorScheme:ColorScheme
    @State private var showDetail = false
    var date = Date()
    var pollenName : String = ""
    var pollenCount : Double = 0.0
    
    var location : String
    
    var body: some View {
        
        HStack(alignment: .center) {
//            Image(image)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 100)
//                .cornerRadius(10)
//                .padding(.all, 20)
            VStack(alignment: .leading) {
                Spacer()
                Text(date, style: .date)
                    .font(.system(size: 22, weight: .bold, design: .default))
                    .foregroundColor(Color(.secondaryLabel))
                    .padding(.leading, 10)
                HStack{
                    Text("\(pollenCount, specifier: "%.1f") pcm").font(.system(size: 32, weight: .bold, design: .default))
                        .foregroundColor(Color(.label))
                        .padding(.leading, 10)
                }
                
                VStack(alignment: .leading) {
                    Text("Predominant Pollen:")
                        .font(.system(size: 16, weight: .bold, design: .default))
                        .foregroundColor(Color(.secondaryLabel))
                        .padding(.leading, 10)
                        .padding(.top, 5)
                    Text(pollenName)
                        .font(.system(size: 22, weight: .bold, design: .default))
                        .foregroundColor(Color(.label))
                        .padding(.leading, 10)
                        .padding(.top, 5)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            Spacer()
            if location == "calder" {
                NavigationLink(destination: DetailView(date: date, pollenName: pollenName, pollenCount: pollenCount, location: location), isActive: $isLinkActive) {
                    Button(action: {
                        self.isLinkActive = true
                    }) {
                        Image(systemName: "chevron.right.circle")
                            .imageScale(.large)
                            .padding()
                            .foregroundColor(Colors.OrangeEnd)
                    }
                }
            } else {
                NavigationLink(destination: DetailView(date: date, pollenName: pollenName, pollenCount: pollenCount, location: location), isActive: $isLinkActive) {
                    Button(action: {
                        self.isLinkActive = true
                    }) {
                        Image(systemName: "chevron.right.circle")
                            .imageScale(.large)
                            .padding()
                            .foregroundColor(Colors.GradientPurple)
                    }
                }
            }
            
        }
        
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.backgroundColor(for: colorScheme))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.1), lineWidth: 1)
        )
        .padding([.top, .horizontal, .bottom])
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
        
        
    }
}
struct DetailView: View {
    
    let persistanceContainer = PersistenceController.shared
    var date = Date()
    var pollenName : String = ""
    var pollenCount : Double = 0.0
    
    var location : String
    
    var body: some View {
        ScrollView{
            VStack{
                
//                Image(image)
//                    .resizable()
//                    .scaledToFit()
                
                Text(date, style: .date)
                Text(pollenName)
                Text("\(pollenCount, specifier: "%.1f") pcm")
                
                Spacer()
                HomeChartDataView(date: date, pollenName: pollenName, pollenCount: pollenCount, location: location)
                    .environment(\.managedObjectContext, persistanceContainer.container.viewContext)
                //                HStack{
                //                    BarChartView(data: ChartData(values: [("May 10, 2020", 6.0), ("October 21, 2019", 2.0), ("October 20, 2019", 4.0), ("October 19, 2019", 1.0), ("October 18, 2019", 8.0)]), title: "Pollen Count", legend: "particles per cubic meter of air", dropShadow: false )
                //                    PieChartView(labels: ["Ragweed","Mugwort"],data: [67,33], title: "Pollen Types", legend: "Percent of Pollen",dropShadow: false)
                //                }
                
                
                
                
                Spacer()
                
                
                
            }
            
        }.navigationTitle("Detail View")
    }
}

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
    }
    
}

extension Color {
    static let lightCard = Color(.white)
    static let darkCard = Color(.systemGray6)
    
    static func backgroundColor(for colorScheme: ColorScheme) -> Color {
        if colorScheme == .dark {
            return darkCard
        } else {
            return lightCard
        }
    }
}

