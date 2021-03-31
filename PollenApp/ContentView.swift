//
//  ContentView.swift
//  PollenAppSwiftUI
//
//  Created by Sabri Sönmez on 2/14/21.
//

import SwiftUI
import CoreData
import Introspect

struct ContentView: View {
    let persistanceContainer = PersistenceController.shared
    @State var didAppear = false
    @State var appearCount = 0
    @State var date = Date()
    @ObservedObject var networkManager = NetworkManager()
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: PollenLincoln.entity(),sortDescriptors: [])
    private var pollenLincoln: FetchedResults<PollenLincoln>
    @FetchRequest(entity: PollenCalder.entity(), sortDescriptors: [])
    private var pollenCalder: FetchedResults<PollenCalder>
    @State var doubleArray = [Double]()
    @State var isLoading:Bool = false
    @State private var authPath = 0
    @State private var appSetupState = "App NOT setup ☹️"
    @Environment(\.colorScheme) var colorScheme
    // #1
    @AppStorage("needsAppOnboarding") private var needsAppOnboarding: Bool = true
    
    var body: some View {
       
     
        mainView.onAppear {
            
            if !needsAppOnboarding {
                // Scenario #2: User has completed app onboarding
                appSetupState = "App setup 😀"
            }
            
        }
    }
    func refreshData(completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            onLoad()
            completion()
        }
    }
    func onLoad() {
        if didAppear == false {
            self.isLoading = true
            appearCount += 1
            //This is where I loaded my coreData information into normal arrays
            networkManager.loadData(onCompletion: { (successful) in
                print(successful)
                for index in 0...networkManager.sheetsData.pollenDatesLincoln.count - 1 {
                    if(!networkManager.sheetsData.pollenDatesLincoln[index].contains("-") && !networkManager.sheetsData.pollenNamesLincoln[index].contains("-")) {
                        let dateString = networkManager.sheetsData.pollenDatesLincoln[index]
                        // Create Date Formatter
                        let dateFormatter = DateFormatter()
                        // Set Date Format
                        dateFormatter.dateFormat = "MM/dd/yy"
                        // Convert String to Date
                        let dated = dateFormatter.date(from: dateString)
                        
                        let pollenCountString = networkManager.sheetsData.pollenCountLincoln[index]
                        var pollenCountDouble = 0.0
                        if pollenCountString.contains("pcm") {
                            let replaced = pollenCountString.replacingOccurrences(of: "pcm", with: "")
                            var trimmed = replaced
                            if !replaced.contains("."){
                                trimmed = replaced.trimmingCharacters(in: .whitespacesAndNewlines)
                                trimmed.append(".0")
                            }
                            pollenCountDouble += Double(trimmed) ?? 0.0
                            
                        }
                        addDataLincoln(date: dated!  , name: networkManager.sheetsData.pollenNamesLincoln[index], count: pollenCountDouble)
                    }
                }
                
                for index in 0...networkManager.sheetsData.pollenDatesCalder.count - 1{
                    if(!networkManager.sheetsData.pollenDatesCalder[index].contains("-") && !networkManager.sheetsData.pollenNamesCalder[index].contains("-")) {
                        let dateString = networkManager.sheetsData.pollenDatesCalder[index]
                        // Create Date Formatter
                        let dateFormatter = DateFormatter()
                        // Set Date Format
                        dateFormatter.dateFormat = "MM/dd/yy"
                        // Convert String to Date
                        let dated = dateFormatter.date(from: dateString)
                        
                        let pollenCountString = networkManager.sheetsData.pollenCountCalder[index]
                        var pollenCountDouble = 0.0
                        if pollenCountString.contains("pcm") {
                            let replaced = pollenCountString.replacingOccurrences(of: "pcm", with: "")
                            var trimmed = replaced
                            if !replaced.contains("."){
                                trimmed = replaced.trimmingCharacters(in: .whitespacesAndNewlines)
                                trimmed.append(".0")
                            }
                            pollenCountDouble += Double(trimmed) ?? 0.0
                        }
                        
                        addDataCalder(date: dated!  , name: networkManager.sheetsData.pollenNamesCalder[index], count: pollenCountDouble)
                    }
                    
                    self.isLoading = false
                }
            }) { (error) in
                print(error.domain)
            }
        }
        didAppear = true
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved Error: \(error)")
        }
    }
    
    private func addDataLincoln(date:Date, name: String, count:Double) {
        withAnimation {
            let newData = PollenLincoln(context: viewContext)
            newData.date = date
            newData.name = name
            newData.count = count
            saveContext()
        }
        
    }
    private func addDataCalder(date:Date, name: String, count:Double) {
        withAnimation() {
            let newData = PollenCalder(context: viewContext)
            newData.date = date
            newData.name = name
            newData.count = count
            saveContext()
        }
        
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension ContentView {
    
    private var mainView: some View {
        
         
//            Button(action: {
//                needsAppOnboarding = true
//            }) {
//                Text("Reset Onboarding")
//                    .padding(.horizontal, 40)
//                    .padding(.vertical, 15)
//                    .font(Font.title2.bold().lowercaseSmallCaps())
//            }
//            .background(Color.black)
//            .foregroundColor(.white)
        
//
            VStack {
               
                if isLoading || networkManager.loading {
                    ProgressView("Loading Data…")
                        .progressViewStyle(CircularProgressViewStyle())
    
                } else{
                    Picker(selection: $authPath, label: Text("Home Center Path")) {
                        Text("Louis Calder").tag(0)
                        Text("Lincoln Center").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.trailing)
                    .padding(.leading)
                   
                    ScrollView {
                        PullToRefreshView {
                            self.didAppear = false
                            onLoad()
                        }
                        if authPath == 0 {
                            VStack {
                               
                                FetchedObjects(
                                    predicate:  NSPredicate(format: "date >= %@ AND date <= %@", argumentArray: [Calendar.current.date(byAdding: .day, value: -395, to: date)!, Calendar.current.date(byAdding: .day, value: -365, to: date)!]),
                                    sortDescriptors: [
                                        NSSortDescriptor(key: "date", ascending: false)
                                    ])
                                { (pollenCalders: [PollenCalder]) in
                                    
                                    Text(networkManager.sheetsData.titleCalder).font(.headline)
                                    
                                    if pollenCalders[0].name != nil && pollenCalders[0].date != nil {
                                        PollenCardView(date: pollenCalders[0].date!, pollenName: pollenCalders[0].name!, pollenCount: pollenCalders[0].count, location: "calder")
                                    }
                                    
                                    
                                    HomeChartDataView(date: pollenCalders[0].date!, pollenName: pollenCalders[0].name!, pollenCount: pollenCalders[0].count, location: "calder")
                                        .environment(\.managedObjectContext, persistanceContainer.container.viewContext)
                                    
                                    MultiLineChartView(labels: pollenCalders.map { ($0.date ?? date)}, data: [ (pollenCalders.map { $0.count}, GradientColors.orange)], title: "Pollen Data This Month", legend: "particles per cubic meter of air", multiLegend: [ (Colors.OrangeEnd, "Louis Calder"),( Color.clear, "")], form: ChartForm.extraLarge, rateValue: 14, dropShadow:false, names: pollenCalders.map { ($0.name ?? "")}).padding().padding(.bottom)
                                    Text("\(Calendar.current.date(byAdding: .day, value: -395, to: date)!, style: .date) to \(Calendar.current.date(byAdding: .day, value: -365, to: date)!, style: .date)").font(.headline).padding()
                                }
    
                            }
                            .animation(.default)
                            .transition(.move(edge: .leading))
                            .padding()
                        }
                        if authPath == 1 {
                            VStack {
                               
    
                                FetchedObjects(
                                    predicate:  NSPredicate(format: "date >= %@ AND date <= %@", argumentArray: [Calendar.current.date(byAdding: .day, value: -395, to: date)!, Calendar.current.date(byAdding: .day, value: -365, to: date)!]),
                                    sortDescriptors: [
                                        NSSortDescriptor(key: "date", ascending: false)
                                    ])
                                { (pollenLincolns: [PollenLincoln]) in
                                    Text(networkManager.sheetsData.titleLincoln).font(.headline)
                                    if pollenLincolns[0].name != nil && pollenLincolns[0].date != nil {
                                        PollenCardView(date: pollenLincolns[0].date!, pollenName: pollenLincolns[0].name!, pollenCount: pollenLincolns[0].count, location: "lincoln")
                                    }
        
        
                                    HomeChartDataView(date: pollenLincolns[0].date!, pollenName: pollenLincolns[0].name!, pollenCount: pollenLincolns[0].count, location: "lincoln")
                                        .environment(\.managedObjectContext, persistanceContainer.container.viewContext)
                                    
                                    MultiLineChartView(labels: pollenLincolns.map { ($0.date ?? date)}, data: [ (pollenLincolns.map { $0.count}, GradientColors.purple)], title: "Pollen Data This Month", legend: "particles per cubic meter of air", multiLegend: [ (Color(hexString: "741DF4"), "Lincoln Center"),( Color.clear, "")], form: ChartForm.extraLarge, rateValue: 14, dropShadow:false, names: pollenLincolns.map { ($0.name ?? "")}).padding().padding(.bottom)
                                    Text("\(Calendar.current.date(byAdding: .day, value: -395, to: date)!, style: .date) to \(Calendar.current.date(byAdding: .day, value: -365, to: date)!, style: .date)").font(.headline).padding()
                                }
//                                Button(action: {
//                                              needsAppOnboarding = true
//                                          }) {
//                                              Text("Reset Onboarding")
//                                                  .padding(.horizontal, 40)
//                                                  .padding(.vertical, 15)
//                                                  .font(Font.title2.bold().lowercaseSmallCaps())
//                                          }
//                                          .background(Color.black)
//                                          .foregroundColor(.white)
//                                          .cornerRadius(40)
                            }.animation(.default)
                            .transition(.move(edge: .trailing))
                            .padding()
                        }
                    }
                }
            }
    
            .navigationTitle("Home")
            .onAppear(perform: onLoad)
            .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .global)
                        .onEnded { value in
                            let horizontalAmount = value.translation.width as CGFloat
                            let verticalAmount = value.translation.height as CGFloat
    
                            if abs(horizontalAmount) > abs(verticalAmount) {
                                //                            print(horizontalAmount < 0 ? "left swipe" : "right swipe")
                                if horizontalAmount < 0 {
                                    authPath = 1
                                } else {
                                    authPath = 0
                                }
                            }
                        })
            // #1
            .sheet(isPresented:$needsAppOnboarding) {
                
                // Scenario #1: User has NOT completed app onboarding
                OnboardingView()
            }
            
            // #2
            .onChange(of: needsAppOnboarding) { needsAppOnboarding in
                
                if !needsAppOnboarding {
                    
                    // Scenario #2: User has completed app onboarding during current app launch
                    appSetupState = "App setup 😀"
                }
            
        }
    }
}
