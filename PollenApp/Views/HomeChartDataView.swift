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
    @Environment (\.colorScheme) var colorScheme:ColorScheme
    @State var dateArray = [String]()
    @State var barChartArray = [(String,Double)]()
    @State var lineChartArray = [(String,Double)]()
    @State var pieLabelsArray = [String]()
    @State var pollenNamesArray = [String]()
    @State var pieValuesArray = [Double]()
    let chartStyle = ChartStyle(backgroundColor: Color(.systemBackground), accentColor: Color(hexString: "C501B0"), secondGradientColor: Color(hexString: "741DF4"), textColor: Color(.label), legendTextColor: Color.gray, dropShadowColor: Color.gray )
    let pieChartStyle = ChartStyle(
        backgroundColor: Color(.systemBackground),
        accentColor: Color(hexString: "741DF4"),
        secondGradientColor: Color(hexString: "C501B0"),
        textColor: Color(.label),
        legendTextColor: Color(.secondaryLabel),
        dropShadowColor: Color.gray)
    let lineStyle = ChartStyle(
        backgroundColor: Color(.systemBackground),
        accentColor: Color(hexString: "741DF4"),
        secondGradientColor: Color(hexString: "C501B0"),
        textColor: Color(.label),
        legendTextColor: Color(.secondaryLabel),
        dropShadowColor: Color.gray)
    //    @FetchRequest(entity: PollenLincoln.entity(),sortDescriptors: [])
    //    private var pollenLincoln: FetchedResults<PollenLincoln>
    //    @FetchRequest(entity: PollenCalder.entity(), sortDescriptors: [])
    //    private var pollenCalder: FetchedResults<PollenCalder>
    
    
    var body: some View {
        
        VStack(alignment: .leading) {
            if location == "lincoln"{
                FetchedObjects(
                    predicate:  NSPredicate(format: "date >= %@ AND date <= %@", argumentArray: [Calendar.current.date(byAdding: .day, value: -7, to: date)!, date]),
                    sortDescriptors: [
                        NSSortDescriptor(key: "date", ascending: false)
                    ])
                { (pollenLincoln: [PollenLincoln]) in
                    Text("Pollen Make Up of Today").font(.headline).padding()
                    Spacer()
                    PieChartView(labels: pieLabelsArray, data: pieValuesArray, title: "Pollen Types", legend: "Percent of Pollen",style: pieChartStyle, form: ChartForm.extraLarge, dropShadow: true).padding()
                    Text("Pollen Data Within the Past 7 Days").font(.headline).padding()
                    Spacer()
                    HStack {
                        BarChartView(data: ChartData(values: barChartArray), title: "Pollen Count", legend: "particles per cubic meter of air", style: chartStyle, dropShadow: true ).onDisappear(perform: {
                             dateArray.removeAll()
                             barChartArray .removeAll()
                             lineChartArray .removeAll()
                             pieLabelsArray .removeAll()
                             pollenNamesArray .removeAll()
                             pieValuesArray .removeAll()
                            
                        })
                            .onAppear(perform: {
                            for i in pollenLincoln {
                                let format = i.date!.getFormattedDate(format: "MM/dd/yyyy")
                                barChartArray.append((format, i.count))
                                
                                
                                if i.name! == "No Pollen" {
                                    pollenNamesArray.append(i.name!.trimmingCharacters(in: .whitespacesAndNewlines))
                                    
                                }
                                else if i.name!.contains(",") {
                                    let delimeteredNames = i.name!.components(separatedBy: ",")
                                    for item in delimeteredNames {
                                        let pollenArray = item.components(separatedBy: CharacterSet.decimalDigits)
                                        pollenNamesArray.append(pollenArray[0].trimmingCharacters(in: .whitespacesAndNewlines))
                                        
                                        
                                        
                                    }
                                    
                                }
                                else if !i.name!.contains(","){
                                    let delimeteredNames = i.name!.components(separatedBy: " ")
                                    pollenNamesArray.append(delimeteredNames[0].trimmingCharacters(in: .whitespacesAndNewlines))
                                    //                               print(delimetered)
                                    //                               pollenNameS
                                    //                                print(delimetered)
                                }
                                
                            }
                            
                            var counts: [String: Int] = [:]
                            
                            pollenNamesArray.forEach { counts[$0, default: 0] += 1 }
                            var lineChartSorted = [(String,Double)]()
                            for item in counts {
                                lineChartSorted.append((item.key, Double(item.value)))
                            }
                            lineChartArray = lineChartSorted.sorted(by: { $0.0 < $1.0})
                            
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
                        LineChartView(data:  ChartData(values: lineChartArray), title: "Most Frequent", legend: "Pollen Types", style: lineStyle, rateValue:0, dropShadow: true) // legend is optional
                    }.padding()
                    
                    
                    
                }
            }
            
            else if location == "calder" {
                FetchedObjects(
                    predicate:  NSPredicate(format: "date >= %@ AND date <= %@", argumentArray: [Calendar.current.date(byAdding: .day, value: -7, to: date)!, date]),
                    sortDescriptors: [
                        NSSortDescriptor(key: "date", ascending: false)
                    ])
                { (pollenCalder: [PollenCalder]) in
                    Text("Pollen Make Up of Today:").font(.headline).padding()
                    PieChartView(labels: pieLabelsArray, data: pieValuesArray, title: "Pollen Types", legend: "Percent of Pollen" , form: ChartForm.extraLarge, dropShadow: true).padding()
                    Text("Pollen Data Within the Past 7 Days").font(.headline).padding()
                    
                    HStack{
                        BarChartView(data: ChartData(values: barChartArray), title: "Pollen Count", legend: "particles per cubic meter of air", dropShadow: true)
                            .onDisappear(perform: {
                                 dateArray.removeAll()
                                 barChartArray .removeAll()
                                 lineChartArray .removeAll()
                                 pieLabelsArray .removeAll()
                                 pollenNamesArray .removeAll()
                                 pieValuesArray .removeAll()
                                
                                
                            }).onAppear(perform: {
                            
                            for i in pollenCalder {
                                let format = i.date!.getFormattedDate(format: "MM/dd/yyyy")
                                barChartArray.append((format, i.count))
                                
                                if i.name! == "No Pollen" {
                                    pollenNamesArray.append(i.name!.trimmingCharacters(in: .whitespacesAndNewlines))
                                    
                                }
                                
                                else if i.name!.contains(",") {
                                    let delimeteredNames = i.name!.components(separatedBy: ",")
                                    for item in delimeteredNames {
                                        let pollenArray = item.components(separatedBy: CharacterSet.decimalDigits)
                                        pollenNamesArray.append(pollenArray[0].trimmingCharacters(in: .whitespacesAndNewlines))
                                        
                                        
                                        
                                    }
                                    
                                }
                                else if !i.name!.contains(","){
                                    let delimeteredNames = i.name!.components(separatedBy: " ")
                                    pollenNamesArray.append(delimeteredNames[0].trimmingCharacters(in: .whitespacesAndNewlines))
                                    //                               print(delimetered)
                                    //                               pollenNameS
                                    //                                print(delimetered)
                                }
                            }
                            var counts: [String: Int] = [:]
                            
                            pollenNamesArray.forEach { counts[$0, default: 0] += 1 }
                            var lineChartSorted = [(String,Double)]()
                            for item in counts {
                                lineChartSorted.append((item.key, Double(item.value)))
                            }
                            lineChartArray = lineChartSorted.sorted(by: { $0.0 < $1.0})
                            
                            
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
                        LineChartView(data:  ChartData(values: lineChartArray), title: "Pollen Type", legend: "Frequency", rateValue:0, dropShadow: true)
                    }.padding()
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
 
