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
    @State var makeInt = 0
    @State var searchUrl : String = "default"
    
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
                        let _ = makeInt = 0
                        ForEach(audiModels, id: \.self) {
                            Text($0).padding(100)
                        }
                    }.pickerStyle(.menu).padding(5).background(Color.white)
                case "BMW":
                    Picker("Select a model", selection: $model) {
                        let _ = makeInt = 9
                        ForEach(bmwModels, id: \.self) {
                            Text($0).padding(100)
                        }
                        
                    }.pickerStyle(.menu).padding(5).background(Color.white)
                case "Toyota":
                    Picker("Select a model", selection: $model) {
                        let _ = makeInt = 79
                        ForEach(toyotaModels, id: \.self) {
                            Text($0).padding(100)
                        }
                        
                    }.pickerStyle(.menu).padding(5).background(Color.white)
                case "Volkswagen":
                    Picker("Select a model", selection: $model) {
                        let _ = makeInt = 84
                        ForEach(volkswagenModels, id: \.self) {
                            Text($0).padding(100)
                        }
                        
                    }.pickerStyle(.menu).padding(5).background(Color.white)
                case "Alfa Romeo":
                    Picker("Select a model", selection: $model) {
                        let _ = makeInt = 2
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
                NavigationLink(destination: SearchResultsView()) {
                    prettyBackgound(text: "Go!", size: 50)
                }.navigationTitle("").simultaneousGesture(TapGesture().onEnded{
                    prepareSearchRequest()
                    performSearchRequest()
                })
            }
        }
    }
    
    func makeBrandIdFromBrand() {
        switch brand {
        case "Alfa Romeo" :
            brand = brandIds["Alfa Romeo"]!
        case "BMW" :
            brand = brandIds["BMW"]!
        case "Toyota" :
            brand = brandIds["Toyota"]!
        default:
            brand = "default"
        }
    }
    
    func prepareSearchRequest() {
        makeBrandIdFromBrand()
        if (brand == "default") {
            searchUrl = "s_yers[0]=\(selectedYearFrom)&po_yers[0]=\(selectedYearTill)&price_ot=0&price_do=\(maxPrice)"
        } else
        
        if (model == "default") {
            searchUrl = "s_yers[0]=\(selectedYearFrom)&po_yers[0]=\(selectedYearTill)&price_ot=0&price_do=\(maxPrice)&marka_id[0]=\(brand)"
        } else
        
        if (model != "default") {
            searchUrl = "s_yers[0]=\(selectedYearFrom)&po_yers[0]=\(selectedYearTill)&price_ot=0&price_do=\(maxPrice)&marka_id[0]=\(brand)&model_id[0]=\(model)"
        }
        else {
            searchUrl = "wrong request"
        }
    }
    
    func performSearchRequest() {
        let example = "make=84&maxPrice=12000&yearFrom=2010&yearTill=2022&model=2692"
        let url = URL(string: baseUrl + getByPriceYearAndMake + searchUrl)!
        print("Peforming search request: " + url.absoluteString)
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
    
    func prettyBackgound(text: String, size: Int) -> some View {
        Text(text).foregroundColor(Color.white).padding(20).cornerRadius(30).font(.system(size: CGFloat(size))).background(Color.purple).cornerRadius(5)
    }

    struct MainPageView_Previews: PreviewProvider {
        static var previews: some View {
            MainPageView()
        }
    }
}
