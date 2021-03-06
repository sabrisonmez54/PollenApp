//
//  ChartsView.swift
//  PollenApp
//
//  Created by Sabri Sönmez on 3/28/21.
//

import SwiftUI
import CoreData

struct ChartsView: View {
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    @State private var chosenDateCalder = Date()
    @State private var chosenDateCalder2 = Date()
    @State private var chosenDateLincoln = Date()
    @State private var chosenDateLincoln2 = Date()
    @State private var selectedCenterIndex = 0
    
    var body: some View {
        
        VStack {
            Picker("Favorite Color", selection: $selectedCenterIndex, content: {
                Text("Louis Calder").tag(0)
                Text("Lincoln Center").tag(1)
            }).pickerStyle(SegmentedPickerStyle())
            .padding(.trailing)
            .padding(.leading)
            ScrollView{
                if selectedCenterIndex == 1 {
                    VStack{
                        Text("Pollen data within selected time period").font(.headline).padding(.bottom)
                        
                        DatePicker("from", selection: $chosenDateCalder, displayedComponents: [.date]).padding(.leading).padding(.trailing)
                        
                        DatePicker("to", selection: $chosenDateCalder2, displayedComponents: [.date]).padding(.leading).padding(.trailing)
                        
                        Spacer()
                        
                        FetchedObjects(
                            predicate:  NSPredicate(format: "date >= %@ AND date < %@", argumentArray: [chosenDateCalder, chosenDateCalder2]),
                            sortDescriptors: [
                                NSSortDescriptor(key: "date", ascending: false)
                            ])
                        { (pollenLincolns: [PollenLincoln]) in
                            MultiLineChartView(labels: pollenLincolns.map { ($0.date ?? chosenDateCalder)}, data: [ (pollenLincolns.map { $0.count}, GradientColors.purple)], title: "Lincoln Center", multiLegend: [ (Color(hexString: "741DF4"), ""),( Color.clear, "")], form: ChartForm.extraLarge, rateValue: 0, dropShadow:false, names: pollenLincolns.map { ($0.name ?? "")}).padding(.top).padding(.bottom)
                            
                            Text("(Department of Natural Sciences) NYC, NY").font(.headline).padding(.top)
                        }
                    }
                    .animation(.default)
                    .transition(.move(edge: .leading))
                    .padding()
                    
                    
                } else {
                    VStack{
                        Text("Pollen data within selected time period").font(.headline).padding(.bottom)
                        
                        DatePicker("from", selection: $chosenDateLincoln, displayedComponents: [.date]).padding(.leading).padding(.trailing)
                        
                        DatePicker("to", selection: $chosenDateLincoln2, displayedComponents: [.date]).padding(.leading).padding(.trailing)
                        
                        Spacer()
                        FetchedObjects(
                            predicate:  NSPredicate(format: "date >= %@ AND date < %@", argumentArray: [chosenDateLincoln, chosenDateLincoln2]),
                            sortDescriptors: [
                                NSSortDescriptor(key: "date", ascending: false)
                            ])
                        { (pollenCalders: [PollenCalder]) in
                            MultiLineChartView(labels: pollenCalders.map { ($0.date ?? chosenDateLincoln)}, data: [ (pollenCalders.map { $0.count}, GradientColors.orange)], title: "Louis Calder Center", multiLegend: [ ( Colors.OrangeEnd, ""),( Color.clear, "")], form: ChartForm.extraLarge, rateValue: 0, dropShadow:false, names: pollenCalders.map { ($0.name ?? "")}).padding(.top).padding(.bottom)
                            Text("(Biological Station) Armonk, NY").font(.headline).padding(.top)
                            
                        }
                    }.animation(.default)
                    .transition(.move(edge: .trailing))
                    .padding()
                }
                
            }
            
        }.navigationTitle("Chart")
        .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .global)
                    .onEnded { value in
                        let horizontalAmount = value.translation.width as CGFloat
                        let verticalAmount = value.translation.height as CGFloat
                        
                        if abs(horizontalAmount) > abs(verticalAmount) {
                            //                            print(horizontalAmount < 0 ? "left swipe" : "right swipe")
                            if horizontalAmount < 0 {
                                selectedCenterIndex = 1
                            } else {
                                selectedCenterIndex = 0
                            }
                        }
                    })
        
    }
}

struct ChartsView_Previews: PreviewProvider {
    static var previews: some View {
        ChartsView()
    }
}
