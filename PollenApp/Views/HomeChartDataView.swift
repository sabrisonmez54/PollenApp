//
//  HomeChartDataView.swift
//  PollenApp
//
//  Created by Sabri Sönmez on 3/21/21.
//

import SwiftUI
import CoreData

struct HomeChartDataView: View {
    
    var date : Date
    var pollenName : String
    var pollenCount : Double
    var location : String
    @State var dateArray = [String]()
    @State var barChartArray = [(String,Double)]()
    @State var pieLabelsArray = [String]()
    @State var pieValuesArray = [Double]()
    
    //    @FetchRequest(entity: PollenLincoln.entity(),sortDescriptors: [])
    //    private var pollenLincoln: FetchedResults<PollenLincoln>
    //    @FetchRequest(entity: PollenCalder.entity(), sortDescriptors: [])
    //    private var pollenCalder: FetchedResults<PollenCalder>
    
    
    var body: some View {
        
        HStack{
            if location == "lincoln"{
                FetchedObjects(
                    predicate:  NSPredicate(format: "date >= %@ AND date <= %@", argumentArray: [Calendar.current.date(byAdding: .day, value: -7, to: date)!, date]),
                    sortDescriptors: [
                        NSSortDescriptor(key: "date", ascending: false)
                    ])
                { (pollenLincoln: [PollenLincoln]) in
                    BarChartView(data: ChartData(values: barChartArray), title: "Pollen Count", legend: "particles per cubic meter of air", dropShadow: false ).onAppear(perform: {
                        for i in pollenLincoln {
                            let format = i.date!.getFormattedDate(format: "MM/dd/yyyy")
                            barChartArray.append((format, i.count))
                        }
                        let dataVar = 0.0
                        if pollenName == "No Pollen" {
                            pieLabelsArray.append(pollenName)
                            pieValuesArray.append(dataVar)
                        }
                        else if pollenName.contains(",") {
                            let delimetered = pollenName.components(separatedBy: ",")
                            for item in delimetered {
                                let pollenArray = item.components(separatedBy: CharacterSet.decimalDigits)
                                
                                let label = pollenArray[0].trimmingCharacters(in: .whitespacesAndNewlines)
                                print(label)
                                pieLabelsArray.append(String(label))
                                
                                let stringArray = item.components(separatedBy: CharacterSet.decimalDigits.inverted)
                                for item in stringArray {
                                    
                                    if let number = Double(item) {
                                        pieValuesArray.append(number)
                                        
                                    }
                                }
                            }
                            
                        }
                        else {
                            let delimetered = pollenName.components(separatedBy: " ")
                            let percentVar = delimetered[1].components(separatedBy: "%")
                            pieValuesArray.append(Double(percentVar[0])!)
                            pieLabelsArray.append(delimetered[0])
                            //                                print(delimetered)
                        }
                    })
                    
                    PieChartView(labels: pieLabelsArray, data: pieValuesArray, title: "Pollen Types", legend: "Percent of Pollen",dropShadow: false)
                }
            }
            
            else if location == "calder" {
                FetchedObjects(
                    predicate:  NSPredicate(format: "date >= %@ AND date <= %@", argumentArray: [Calendar.current.date(byAdding: .day, value: -7, to: date)!, date]),
                    sortDescriptors: [
                        NSSortDescriptor(key: "date", ascending: false)
                    ])
                { (pollenCalder: [PollenCalder]) in
                    BarChartView(data: ChartData(values: barChartArray), title: "Pollen Count", legend: "particles per cubic meter of air", dropShadow: false ).onAppear(perform: {
                        for i in pollenCalder {
                            let format = i.date!.getFormattedDate(format: "MM/dd/yyyy")
                            barChartArray.append((format, i.count))
                            //                            pieValuesArray.append(i.count)
                            //                            pieLabelsArray.append(format)
                            
                        }
                        let dataVar = 0.0
                        if pollenName == "No Pollen" {
                            pieLabelsArray.append(pollenName)
                            pieValuesArray.append(dataVar)
                        }
                        else if pollenName.contains(",") {
                            let delimetered = pollenName.components(separatedBy: ",")
                            for item in delimetered {
                                let pollenArray = item.components(separatedBy: CharacterSet.decimalDigits)
                                let label = pollenArray[0].trimmingCharacters(in: .whitespacesAndNewlines)
                                print(label)
                                pieLabelsArray.append(String(label))
                                
                                let stringArray = item.components(separatedBy: CharacterSet.decimalDigits.inverted)
                                for item in stringArray {
                                    pieLabelsArray.append(item)
                                    if let number = Double(item) {
                                        pieValuesArray.append(number)
                                        print(number)
                                    }
                                }
                            }
                            print(delimetered)
                        }
                        else {
                            let delimetered = pollenName.components(separatedBy: " ")
                            let percentVar = delimetered[1].components(separatedBy: "%")
                            pieValuesArray.append(Double(percentVar[0])!)
                            pieLabelsArray.append(delimetered[0])
                            //                                print(delimetered)
                        }
                        
                    })
                    //                    let rateDouble = pieValuesArray[0] - pieValuesArray[1]
                    //                    let rateInt = Int(rateDouble)
                    //                    LineChartView(data: pieValuesArray, title: "Title", legend: "Legendary", rateValue: 50)
                    PieChartView(labels: pieLabelsArray, data: pieValuesArray, title: "Pollen Types", legend: "Percent of Pollen",dropShadow: false)
                    //                    PieChartView(labels: pieLabelsArray, data: pieValuesArray, title: "Pollen Types", legend: "Percent of Pollen",dropShadow: false).onAppear(perform: {
                    //
                    //                        //                        for i in pollenCalder {
                    ////                            let dataVar = 0.0
                    ////                            if i.name! == "No Pollen" {
                    ////                                pieLabelsArray.append(i.name!)
                    ////                                pieValuesArray.append(dataVar)
                    ////                            } else if i.name!.contains("Unidentified") {
                    ////                                let delimetered = i.name!.components(separatedBy: ",")
                    ////                                print(delimetered)
                    ////                            }
                    ////                            else if i.name!.contains(",") {
                    ////                                let delimetered = i.name!.components(separatedBy: ",")
                    ////                                print(delimetered)
                    ////                            }
                    ////                            else {
                    ////                                let delimetered = i.name!.components(separatedBy: " ")
                    ////                                print(delimetered)
                    ////                            }
                    ////
                    ////
                    ////                            pieValuesArray.append(i.count)
                    ////                        }
                    //                    })
                }
            }
            
        }
    }
}

struct HomeChartDataView_Previews: PreviewProvider {
    static var previews: some View {
        let date = Date()
        HomeChartDataView (date: date, pollenName: "Oak 100%", pollenCount:  6.0, location: "lincoln")
    }
}
extension Date {
    static func changeDaysBy(days : Int) -> Date {
        let currentDate = Date()
        var dateComponents = DateComponents()
        dateComponents.day = days
        return Calendar.current.date(byAdding: dateComponents, to: currentDate)!
    }
}

extension Date {
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}
extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}

