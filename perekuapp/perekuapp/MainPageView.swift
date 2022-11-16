//
//  MainPageView.swift
//  perekuapp
//
//  Created by Ievgenii Podovinnikov on 24.09.2022.
//

import SwiftUI

struct MainPageView: View {
    
    @State var brand: String = "default"
    @State var model: String =  "default"
    @State var maxPrice: Int = 5000
    @State var selectedYearFrom = 1988
    @State var currentYear = Calendar.current.component(.year, from: Date())
    @State var selectedYearTill = 2022
    @State var prices = [1000, 2000, 3000, 5000, 6000, 7000, 8000, 9000, 10000, 15000, 20000, 25000, 30000]
    @State var price = 5000
    @State var searchUrl : String = "default"
    @State var endpoint = "default"
    @State var searchResults = [SingleResult]()
    
    var body: some View {
        ZStack {
            Image("porsche911").resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            VStack {
                prettyBackgound(text: "Select a brand:", size: 30)
                Picker("Select a brand", selection: $brand) {
                    ForEach(brands, id: \.self) {
                        Text($0).padding(100)
                    }
                }.pickerStyle(.menu).padding(5).background(Color.white)
                prettyBackgound(text: "Select a model", size: 30)
                switch brand {
                case "Audi":
                    Picker("Select a model", selection: $model) {
                        ForEach(audiModels, id: \.self) {
                            Text($0).padding(100)
                        }
                    }.pickerStyle(.menu).padding(5).background(Color.white)
                case "BMW":
                    Picker("Select a model", selection: $model) {
                        ForEach(bmwModels, id: \.self) {
                            Text($0).padding(100)
                        }
                        
                    }.pickerStyle(.menu).padding(5).background(Color.white)
                case "Toyota":
                    Picker("Select a model", selection: $model) {
                        ForEach(toyotaModels, id: \.self) {
                            Text($0).padding(100)
                        }
                        
                    }.pickerStyle(.menu).padding(5).background(Color.white)
                case "Volkswagen":
                    Picker("Select a model", selection: $model) {
                        ForEach(volkswagenModels, id: \.self) {
                            Text($0).padding(100)
                        }
                        
                    }.pickerStyle(.menu).padding(5).background(Color.white)
                case "Alfa Romeo":
                    Picker("Select a model", selection: $model) {
                        ForEach(alfaModels, id: \.self) {
                            Text($0).padding(100)
                        }
                        
                    }.pickerStyle(.menu).padding(5).background(Color.white)
                case "Mercedes":
                    Picker("Select a model", selection: $model) {
                        
                        ForEach(mercedesModels, id: \.self) {
                            Text($0).padding(100)
                        }
                        
                    }.pickerStyle(.menu).padding(5).background(Color.white)
                default:
                    Picker("Select a model", selection: $model) {
                        ForEach(defaultModelPicker, id: \.self) {
                            Text($0).padding(100)
                        }
                    }.padding(5).background(Color.white)
                }
                prettyBackgound(text: "Select a year from", size: 20)
                Picker("", selection: $selectedYearFrom) {
                    ForEach(1970...currentYear, id: \.self) {
                        Text(String($0))
                    }
                }.pickerStyle(.menu).padding(5).background(Color.white)
                
                prettyBackgound(text: "Select a year till", size: 20)
                Picker("", selection: $selectedYearTill) {
                    ForEach(selectedYearFrom...currentYear, id: \.self) {
                        Text(String($0))
                    }
                }.pickerStyle(.menu).padding(5).background(Color.white)
                Picker("Max price", selection: $maxPrice) {
                    ForEach(prices, id: \.self) {
                        Text(String($0))
                    }
                }.pickerStyle(.menu).padding(5).background(Color.white)
                NavigationLink(destination: SearchResultsView(searchResults: searchResults)) {
                    prettyBackgound(text: "Go!", size: 50)
                }.navigationTitle("").simultaneousGesture(TapGesture().onEnded{
                    prepareSearchRequest()
                    performSearchRequest()
                })
            }
        }
    }
    
    func prepareSearchRequest() {
        if (brand == "default") {
            endpoint = getByPriceAndYear
            searchUrl = "yearFrom=\(selectedYearFrom)&yearTill=\(selectedYearTill)&maxPrice=\(maxPrice)"
        }
        
        if (model == "default") {
            endpoint = getByPriceYearAndMake
            searchUrl = "yearFrom=\(selectedYearFrom)&yearTill=\(selectedYearTill)&maxPrice=\(maxPrice)&make=\(brand)"
        } else {
            endpoint = getByPriceYearMakeAndModel
            searchUrl = "yearFrom=\(selectedYearFrom)&yearTill=\(selectedYearTill)&maxPrice=\(maxPrice)&make=\(brand)&model=\(model)"
        }
    }
    
    func performSearchRequest() {
        print(baseUrl + endpoint + searchUrl)
        let urlString = baseUrl + endpoint + searchUrl
        print("Peforming search request: " + urlString)
        DispatchQueue.global().async {
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    // we're OK to parse!
                    parseResults(json: data)
                }
            }
        }
    }
    
    func parseResults(json: Data) {
        let decoder = JSONDecoder()

        searchResults = try! decoder.decode([SingleResult].self, from: json) as! [MainPageView.SingleResult]
        print(searchResults)
        print("Search results count is \(searchResults.count)")
    }

    
    func prettyBackgound(text: String, size: Int) -> some View {
        Text(text).foregroundColor(Color.white).padding(20).cornerRadius(30).font(.system(size: CGFloat(size))).background(Color.purple).cornerRadius(5)
    }
    
    struct SingleResult: Codable, Identifiable {
        let id = UUID()
        var autoData: AutoData
        var title: String
        var linkToView: String
        var locationCityName: String
        var markName: String
        var modelName: String
        var USD: String
        var VIN: String
    }

    class AllResults: Codable {
        var results: [SingleResult]
    }
    
    struct AutoData: Codable, Identifiable {
        let id = UUID()
        var autoId: String
        var description: String
        var year: String
        var fuelName: String
        var driveName: String
        var race: String
    }
    
    struct MainPageView_Previews: PreviewProvider {
        static var previews: some View {
            MainPageView()
        }
    }
}
