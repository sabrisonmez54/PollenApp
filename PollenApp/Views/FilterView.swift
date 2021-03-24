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
    var frameworks = ["Date", "Pollen Name", "Pollen Count"]
    @State private var selectedFrameworkIndex = 0
    @State private var selectedDateSearchIndex = 0
    @State private var chosenDate = Date()
    @State private var chosenDate2 = Date()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        VStack {
            Picker("Favorite Color", selection: $selectedCenterIndex, content: {
                Text("Lincoln Center").tag(0)
                Text("Louis Calder").tag(1)
            }).pickerStyle(SegmentedPickerStyle())
            if selectedCenterIndex == 0 {
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
                            SearchBar(sText: $searchText).padding(.bottom, 0)
                            FetchedObjects(
                                predicate: NSPredicate(format: "self.count.stringValue CONTAINS %@", searchText),
                                sortDescriptors: [
                                    NSSortDescriptor(key: "count", ascending: true)
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
                            SearchBar(sText: $searchText)
                            FetchedObjects(
                                predicate: NSPredicate(format: "self.count.stringValue CONTAINS %@", searchText),
                                sortDescriptors: [
                                    NSSortDescriptor(key: "count", ascending: true)
                                ])
                            { (pollenCalder: [PollenCalder]) in
                                List {
                                    ForEach(pollenCalder) { pollen in
                                        
                                        ExcelDataRow(date: pollen.date!, pollenName: pollen.name!, pollenCount: pollen.count)
                                        
                                    }
                                }
                            }
                        }                        }
                }
            }
        }.navigationTitle("Search")
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


