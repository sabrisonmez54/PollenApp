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
    
    private let range = "A20:B23"
    private let api_url_base = "https://spreadsheets.google.com/feeds/list/1JgdxwstIJVet8rVMbegqCS72kFtFLt8jr8v_y-3gVos/1/public/full?alt=json"
    init() {
        loading = true
//        loadData()
     
    }
    
    public func loadData(onCompletion: @escaping (Bool) -> Void, onError: @escaping (NSError) -> Void) {
        guard let url = URL(string: "\(api_url_base)") else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("some error occured")
            } else {
                
                if let urLincolnontent =  data {
                    
                    do{
                        let jsonResult = try JSONSerialization.jsonObject(with: urLincolnontent, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        guard let newValue = jsonResult as? [String: Any] else {
                            print("invalid format")
                            return
                        }
                        
                        let feedValues = newValue["feed"]! as! Dictionary<String,Any>
                        //                        print(String(describing: type(of: post_paramsValue)))
                        let entryValues = feedValues["entry"] as! NSArray
                        
                        let dateLincoln = entryValues[1] as! Dictionary<String,Any>
                        let valuesDateLincoln = dateLincoln["content"] as! Dictionary<String,Any>
                        let castDateLincoln = valuesDateLincoln["$t"] as! String
                        let parsedDateLincoln = castDateLincoln.components(separatedBy: ", ")
                        
                        let pollenCountLincoln = entryValues[2] as! Dictionary<String,Any>
                        let valuesPollenCountLincoln = pollenCountLincoln["content"] as! Dictionary<String,Any>
                        let castCountLincoln = valuesPollenCountLincoln["$t"] as! String
                        let parsedPollenCountLincoln = castCountLincoln.components(separatedBy: ", ")
                        
                        let pollenNameLincoln = entryValues[4] as! Dictionary<String,Any>
                        let valuesPollenNameLincoln = pollenNameLincoln["content"] as! Dictionary<String,Any>
                        let castNameLincoln = valuesPollenNameLincoln["$t"] as! String
                        let parsedPollenNameLincoln = castNameLincoln.components(separatedBy: ", _")
                         
                        let dateCalder = entryValues[18] as! Dictionary<String,Any>
                        let valuesDateCalder = dateCalder["content"] as! Dictionary<String,Any>
                        let castDateCalder = valuesDateCalder["$t"] as! String
                        let parsedDateCalder = castDateCalder.components(separatedBy: ", ")
                        
                        let pollenCountCalder = entryValues[19] as! Dictionary<String,Any>
                        let valuesPollenCountCalder = pollenCountCalder["content"] as! Dictionary<String,Any>
                        let castCountCalder = valuesPollenCountCalder["$t"] as! String
                        let parsedPollenCountCalder = castCountCalder.components(separatedBy: ", ")
                        
                        let pollenNameCalder = entryValues[21] as! Dictionary<String,Any>
                        let valuesPollenNameCalder = pollenNameCalder["content"] as! Dictionary<String,Any>
                        let castNameCalder = valuesPollenNameCalder["$t"] as! String
                        let parsedPollenNameCalder = castNameCalder.components(separatedBy: ", _")
                                                
                        DispatchQueue.main.async {
                            self.loading = false
                           
                            for i in 0 ..< parsedPollenCountLincoln.count - 1 {
                                if let index = (parsedDateLincoln[i].range(of: ":")?.upperBound)
                                {
                                    // Create String
                                    let date = String(parsedDateLincoln[i].suffix(from: index)).trimmingCharacters(in: .whitespacesAndNewlines)
                                    
                                    self.sheetsData.pollenDatesLincoln.append(date)

                                    self.sheetsData.pollenNamesLincoln.append(String(parsedPollenNameLincoln[i].suffix(from: index).trimmingCharacters(in: .whitespacesAndNewlines)))
                                    self.sheetsData.pollenCountLincoln.append(String(parsedPollenCountLincoln[i].suffix(from: index).trimmingCharacters(in: .whitespacesAndNewlines)))
                                }
                            }
                            
                            for i in 0 ..< parsedPollenCountCalder.count - 1 {
                                if let index = (parsedDateCalder[i].range(of: ":")?.upperBound)
                                {
                                    // Create String
                                    let date = String(parsedDateCalder[i].suffix(from: index)).trimmingCharacters(in: .whitespacesAndNewlines)
                                    
                                    self.sheetsData.pollenDatesCalder.append(date)

                                    self.sheetsData.pollenNamesCalder.append(String(parsedPollenNameCalder[i].suffix(from: index).trimmingCharacters(in: .whitespacesAndNewlines)))
                                    self.sheetsData.pollenCountCalder.append(String(parsedPollenCountCalder[i].suffix(from: index).trimmingCharacters(in: .whitespacesAndNewlines)))
                                }
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
