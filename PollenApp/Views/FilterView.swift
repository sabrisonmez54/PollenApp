//
//  filterView.swift
//  PollenAppSwiftUI
//
//  Created by Sabri Sönmez on 3/19/21.
//

import SwiftUI
import CoreData

struct FilterView: View {
    
    @State private var selectedCenterIndex = 0
    @State private var searchText = ""
    @State private var ascending = true
    var frameworks = ["Date", "Pollen Name", "Pollen Count"]
    @State private var selectedFrameworkIndex = 0
    @State private var selectedDateSearchIndex = 0
    @State private var chosenDate = Date()
    @State private var chosenDate2 = Date()
    var arrayOfNames = ["No filter", "Greater than", "Less than"]
    @State private var selectedCountFilterIndex = 0
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    
    var body: some View {
        VStack {
            Picker("Favorite Color", selection: $selectedCenterIndex, content: {
                Text("Louis Calder").tag(0)
                Text("Lincoln Center").tag(1)
            }).pickerStyle(SegmentedPickerStyle())
            .padding(.trailing)
            .padding(.leading)
            
            if selectedCenterIndex == 1 {
                Form {
                    Section {
                        
                            Picker(selection: $selectedFrameworkIndex, label: Text("Search by")) {
                                ForEach(0 ..< frameworks.count) {
                                    Text(self.frameworks[$0])
                                }
                            }
                        
                    }
                    
                    Section {
                        if selectedFrameworkIndex == 0 {
                            
                            DatePicker("from", selection: $chosenDate, displayedComponents: [.date])
                            
                            Picker("Search date by", selection: $selectedDateSearchIndex, content: {
                                Text("Specific date").tag(0)
                                Text("Date range").tag(1)
                            }).pickerStyle(SegmentedPickerStyle())
                            
                            if selectedDateSearchIndex == 0 {
                                FetchedObjects(
                                    predicate: predicateForDayUsingDate(chosenDate),
                                    sortDescriptors: [
                                        NSSortDescriptor(key: "date", ascending: false)
                                    ])
                                { (pollenLincoln: [PollenLincoln]) in
                                    List {
                                        ForEach(pollenLincoln) { pollen in
                                            
                                            ExcelDataRow(date: pollen.date!, pollenName: pollen.name!, pollenCount: pollen.count)
                                            
                                        }
                                    }
                                }
                            }
                            
                            if selectedDateSearchIndex == 1 {
                                DatePicker("to", selection: $chosenDate2, displayedComponents: [.date])
                                FetchedObjects(
                                    predicate:  NSPredicate(format: "date >= %@ AND date < %@", argumentArray: [chosenDate, chosenDate2]),
                                    sortDescriptors: [
                                        NSSortDescriptor(key: "date", ascending: false)
                                    ])
                                { (pollenLincoln: [PollenLincoln]) in
                                    List {
                                        ForEach(pollenLincoln) { pollen in
                                            
                                            ExcelDataRow(date: pollen.date!, pollenName: pollen.name!, pollenCount: pollen.count)
                                            
                                        }
                                    }
                                }
                            }
                        }
                        
                        
                        
                        if selectedFrameworkIndex == 1 {
                            SearchBar(sText: $searchText).padding(.bottom, 0)
                            FetchedObjects(
                                predicate: NSPredicate(format: "name contains[c] %@", searchText),
                                sortDescriptors: [
                                    NSSortDescriptor(key: "date", ascending: false)
                                ])
                            { (pollenLincoln: [PollenLincoln]) in
                                List {
                                    ForEach(pollenLincoln) { pollen in
                                        
                                        ExcelDataRow(date: pollen.date!, pollenName: pollen.name!, pollenCount: pollen.count)
                                        
                                    }
                                }
                            }
                            
                        }
                        if selectedFrameworkIndex == 2 {
                            HStack {
                                    Picker("Filter by", selection: $selectedCountFilterIndex) {
                                              ForEach(0 ..< arrayOfNames.count) {
                                                  Text(self.arrayOfNames[$0])
                                              }
                                        }
                              
                                Toggle("ascending", isOn: $ascending)
                                    .toggleStyle(SwitchToggleStyle(tint: Color(hexString: "741DF4")))
                            }
                            SearchBar(sText: $searchText).keyboardType(.numberPad)
                            
                            if selectedCountFilterIndex == 0 {
                                FetchedObjects(
                                    predicate: NSPredicate(format: "self.count.stringValue CONTAINS %@", searchText),
                                    sortDescriptors: [
                                        NSSortDescriptor(key: "count", ascending: ascending)
                                    ])
                                { (pollenLincoln: [PollenLincoln]) in
                                    List {
                                        ForEach(pollenLincoln) { pollen in
                                                ExcelDataRow(date: pollen.date!, pollenName: pollen.name!, pollenCount: pollen.count)
                                        }
                                    }
                                }
                                
                            }
                           
                            if selectedCountFilterIndex == 1 {
                                FetchedObjects(
//                                    predicate: NSPredicate(format: "self.count > %@", Double(searchText) ?? 0 as NSNumber),
                                    sortDescriptors: [
                                        NSSortDescriptor(key: "count", ascending: ascending)
                                    ])
                                { (pollenLincoln: [PollenLincoln]) in
                                    List {
                                        ForEach(pollenLincoln) { pollen in
                                            let greaterThan = Double(searchText) ?? 0.0
                                            if pollen.count > greaterThan{
                                                ExcelDataRow(date: pollen.date!, pollenName: pollen.name!, pollenCount: pollen.count)
                                            }
                                            
                                            
                                        }
                                    }
                                }
                            }
                            if selectedCountFilterIndex == 2 {
                                FetchedObjects(
//                                    predicate: NSPredicate(format: "self.count > %@", Double(searchText) ?? 0 as NSNumber),
                                    sortDescriptors: [
                                        NSSortDescriptor(key: "count", ascending: ascending)
                                    ])
                                { (pollenLincoln: [PollenLincoln]) in
                                    List {
                                        ForEach(pollenLincoln) { pollen in
                                            let lessThan = Double(searchText) ?? 0.0
                                            if pollen.count < lessThan{
                                                ExcelDataRow(date: pollen.date!, pollenName: pollen.name!, pollenCount: pollen.count)
                                            }
                                            
                                            
                                        }
                                    }
                                }
                            }
                            
                        }
                        
                    }
                    
                }
                
            } else {
                
                Form {
                    Section {
                        Picker(selection: $selectedFrameworkIndex, label: Text("Search by")) {
                            ForEach(0 ..< frameworks.count) {
                                Text(self.frameworks[$0])
                            }
                        }
                    }
                    Section {
                        if selectedFrameworkIndex == 0 {
                            
                            DatePicker("from", selection: $chosenDate, displayedComponents: [.date])
                            
                            Picker("Search date by", selection: $selectedDateSearchIndex, content: {
                                Text("Specific date").tag(0)
                                Text("Date range").tag(1)
                            }).pickerStyle(SegmentedPickerStyle())
                            
                            if selectedDateSearchIndex == 0 {
                                FetchedObjects(
                                    predicate: predicateForDayUsingDate(chosenDate),
                                    sortDescriptors: [
                                        NSSortDescriptor(key: "date", ascending: false)
                                    ])
                                { (pollenCalder: [PollenCalder]) in
                                    List {
                                        ForEach(pollenCalder) { pollen in
                                            
                                            ExcelDataRow(date: pollen.date!, pollenName: pollen.name!, pollenCount: pollen.count)
                                            
                                        }
                                    }
                                }
                            }
                            
                            if selectedDateSearchIndex == 1 {
                                DatePicker("to", selection: $chosenDate2, displayedComponents: [.date])
                                
                                FetchedObjects(
                                    predicate:  NSPredicate(format: "date >= %@ AND date < %@", argumentArray: [chosenDate, chosenDate2]),
                                    sortDescriptors: [
                                        NSSortDescriptor(key: "date", ascending: false)
                                    ])
                                { (pollenCalder: [PollenCalder]) in
                                    List {
                                        ForEach(pollenCalder) { pollen in
                                            
                                            ExcelDataRow(date: pollen.date!, pollenName: pollen.name!, pollenCount: pollen.count)
                                            
                                        }
                                    }
                                }
                            }
                        }
                        if selectedFrameworkIndex == 1 {
                            SearchBar(sText: $searchText)
                            FetchedObjects(
                                predicate: NSPredicate(format: "name contains[c] %@", searchText),
                                sortDescriptors: [
                                    NSSortDescriptor(key: "date", ascending: false)
                                ])
                            { (pollenCalder: [PollenCalder]) in
                                List {
                                    ForEach(pollenCalder) { pollen in
                                        
                                        ExcelDataRow(date: pollen.date!, pollenName: pollen.name!, pollenCount: pollen.count)
                                        
                                    }
                                }
                            }
                        }
                        if selectedFrameworkIndex == 2 {
                            HStack {
                                    Picker("Filter by", selection: $selectedCountFilterIndex) {
                                              ForEach(0 ..< arrayOfNames.count) {
                                                  Text(self.arrayOfNames[$0])
                                              }
                                        }
                              
                                Toggle("ascending", isOn: $ascending)
                                    .toggleStyle(SwitchToggleStyle(tint: Colors.OrangeEnd))
                            }
                            SearchBar(sText: $searchText).keyboardType(.numberPad)
                            
                            if selectedCountFilterIndex == 0 {
                                FetchedObjects(
                                    predicate: NSPredicate(format: "self.count.stringValue CONTAINS %@", searchText),
                                    sortDescriptors: [
                                        NSSortDescriptor(key: "count", ascending: ascending)
                                    ])
                                { (pollenCalder: [PollenCalder]) in
                                    List {
                                        ForEach(pollenCalder) { pollen in
                                                ExcelDataRow(date: pollen.date!, pollenName: pollen.name!, pollenCount: pollen.count)
                                        }
                                    }
                                }
                                
                            }
                           
                            if selectedCountFilterIndex == 1 {
                                FetchedObjects(
//                                    predicate: NSPredicate(format: "self.count > %@", Double(searchText) ?? 0 as NSNumber),
                                    sortDescriptors: [
                                        NSSortDescriptor(key: "count", ascending: ascending)
                                    ])
                                { (pollenCalder: [PollenCalder]) in
                                    List {
                                        ForEach(pollenCalder) { pollen in
                                            let greaterThan = Double(searchText) ?? 0.0
                                            if pollen.count > greaterThan{
                                                ExcelDataRow(date: pollen.date!, pollenName: pollen.name!, pollenCount: pollen.count)
                                            }
                                            
                                            
                                        }
                                    }
                                }
                            }
                            if selectedCountFilterIndex == 2 {
                                FetchedObjects(
//                                    predicate: NSPredicate(format: "self.count > %@", Double(searchText) ?? 0 as NSNumber),
                                    sortDescriptors: [
                                        NSSortDescriptor(key: "count", ascending: ascending)
                                    ])
                                { (pollenCalder: [PollenCalder]) in
                                    List {
                                        ForEach(pollenCalder) { pollen in
                                            let lessThan = Double(searchText) ?? 0.0
                                            if pollen.count < lessThan{
                                                ExcelDataRow(date: pollen.date!, pollenName: pollen.name!, pollenCount: pollen.count)
                                            }
                                            
                                            
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                }
            }
        }.navigationTitle("Search")
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
    
    func predicateForDayUsingDate(_ date: Date) -> NSPredicate {
        
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        // following creates exact midnight 12:00:00:000 AM of day
        let startOfDay = calendar.startOfDay(for: date)
        // following creates exact midnight 12:00:00:000 AM of next day
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        return NSPredicate(format: "date >= %@ AND date < %@", argumentArray: [startOfDay, endOfDay])
    }
    
//    func test() {
//        var string = "Oak 67%, Mugwort 33%"
//        
//    }
    
}



struct SearchBar: UIViewRepresentable {
    @Binding var sText: String
    
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var sText: String
        
        init(sText: Binding<String>) {
            _sText = sText
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            sText = searchText
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            
            searchBar.resignFirstResponder()
            
            searchBar.endEditing(true)
        }
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
        
    }
    
    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(sText: $sText)
    }
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.showsCancelButton = true
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = sText
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        //this does not work
        searchBar.text = ""
        //none of these work
        
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
    }
}


