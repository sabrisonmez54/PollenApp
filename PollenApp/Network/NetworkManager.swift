//
//  NetworkManager.swift
//  PollenAppSwiftUI
//
//  Created by Sabri Sönmez on 3/11/21.
//
//

//import Alamofire
import Foundation
import Combine

class NetworkManager: ObservableObject {
    @Published var excelData = ExcelDataList(results: [])
    @Published var sheetsData = DataArrayModel(titleLincoln: "LINCOLN CENTER (Department of NATURAL SCIENCES)  NYC, NY", pollenDatesLincoln: [], pollenNamesLincoln: [], pollenCountLincoln: [], titleCalder: "LOUIS CALDER CENTER (Biological Station)  Armonk, NY", pollenDatesCalder: [],pollenNamesCalder: [], pollenCountCalder: [])
    @Published var datesArray = [String]()
    @Published var loading = false
    @Published var lincolnDouble = [Double]()
    
    private let range = "A20:B23"
    private let api_key = "AIzaSyDAOv3mnS9Fl_ksQspzppAmUQ-ngyf4ZcQ"
    private let api_url_base2 = "https://sheets.googleapis.com/v4/spreadsheets/1m2Op3h86NFPQUpPDugqACCJatEhR_-ea_C_0nLNdSOE/values/B2%3ABPY23?majorDimension=ROWS&alt=json&key=AIzaSyDAOv3mnS9Fl_ksQspzppAmUQ-ngyf4ZcQ"
    private let api_url_base = "https://spreadsheets.google.com/feeds/list/1m2Op3h86NFPQUpPDugqACCJatEhR_-ea_C_0nLNdSOE/1/public/full?alt=json"
    init() {
        loading = true
//        loadData()
     
    }
    
    public func loadData(onCompletion: @escaping (Bool) -> Void, onError: @escaping (NSError) -> Void) {
        guard let url = URL(string: "\(api_url_base2)") else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("some error occured")
            } else {
                
                if let content = data {
                    
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        guard let newValue = jsonResult as? [String: Any] else {
                            print("invalid format")
                            return
                        }
                        
                        let feedValues = newValue["values"]! as! NSArray
                        
                        let valuesDateLincoln = feedValues[1] as! NSArray
                        let valuesPollenCountLincoln = feedValues[2] as! NSArray
                        let valuesPollenNameLincoln = feedValues[4] as! NSArray
                        
                        let valuesDateCalder = feedValues[18] as! NSArray
                        let valuesPollenCountCalder = feedValues[19] as! NSArray
                        let valuesPollenNameCalder = feedValues[21] as! NSArray
                                                
                        DispatchQueue.main.async {
                            self.loading = false
                            
                            for i in 0 ..< valuesPollenCountLincoln.count - 1 {
                                let date = String(describing: valuesDateLincoln[i]).trimmingCharacters(in: .whitespacesAndNewlines)
                                self.sheetsData.pollenDatesLincoln.append(date)
                                let count = String(describing: valuesPollenCountLincoln[i]).trimmingCharacters(in: .whitespacesAndNewlines)
                                self.sheetsData.pollenCountLincoln.append(count)
                                let name = String(describing: valuesPollenNameLincoln[i]).trimmingCharacters(in: .whitespacesAndNewlines)
                                self.sheetsData.pollenNamesLincoln.append(name)
                            }
                            
                            for i in 0 ..< valuesPollenCountCalder.count - 1 {
                                let date = String(describing: valuesDateCalder[i]).trimmingCharacters(in: .whitespacesAndNewlines)
                                self.sheetsData.pollenDatesCalder.append(date)
                                let count = String(describing: valuesPollenCountCalder[i]).trimmingCharacters(in: .whitespacesAndNewlines)
                                self.sheetsData.pollenCountCalder.append(count)
                                let name = String(describing: valuesPollenNameCalder[i]).trimmingCharacters(in: .whitespacesAndNewlines)
                                self.sheetsData.pollenNamesCalder.append(name)
                            }
                            print("data appended")
                            onCompletion(true)
                        }
                    }catch {
                        print("JSON Preocessing failed")
                    }
                }
            }
        }
        task.resume()
    }
   
}
