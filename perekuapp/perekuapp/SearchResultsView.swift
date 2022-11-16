//
//  SearchResultsView.swift
//  perekuapp
//
//  Created by Ievgenii Podovinnikov on 14.10.2022.
//

import SwiftUI


struct SearchResultsView: View {
    
    var searchResults: [MainPageView.SingleResult]
    @State var photos = [String]()
    
    init() {
        self.searchResults = [MainPageView.SingleResult]()
    }
    
    init(searchResults: [MainPageView.SingleResult]) {
        self.searchResults = searchResults
    }
    
    var body: some View {
        ZStack {
            Image("aventador").resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            VStack {
                ScrollView {
                    ForEach(searchResults.sorted {
                        $0.USD < $1.USD
                    }) { searchResult in
                        let shortDescriptionLine1 = searchResult.autoData.description[0..<27]
                        Section {
                            Image(systemName: "car.2.fill").padding(10).background(Color.purple).foregroundColor(Color.white).cornerRadius(10)
                                .font(.system(size: 20, weight: .light))
                     
                            Text("""
                                \(searchResult.title)\n
                                Город: \(searchResult.locationCityName)\n
                                Год: \(searchResult.autoData.year)\n
                                Топливо: \(searchResult.autoData.fuelName)\n
                                Привод: \(searchResult.autoData.driveName)\n
                                Пробег: \(searchResult.autoData.race)\n
                                Ценник: $ \(searchResult.USD)\n
                                Описание:\n
                                \(shortDescriptionLine1)\n
                                """).padding(30).foregroundColor(Color.white).background(Color.purple).cornerRadius(20).frame(maxWidth: .infinity, maxHeight: .infinity).minimumScaleFactor(0.01)
                            Link("Смотреть",
                                 destination: URL(string: searchResult.linkToView)!).background( Color.green).foregroundColor(Color.white).padding(30).cornerRadius(15)
                        }
                    }
                }
            }
        }
    }
    
    func getPhotos(id: String) {
        let urlString = baseUrl + photosUrl + id
        print("Peforming search request: " + urlString)
        DispatchQueue.global().async {
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    parseResults(json: data)
                }
            }
        }
    }

    func parseResults(json: Data) {
        let decoder = JSONDecoder()
        photos = try! decoder.decode([String].self, from: json) as! [String]
    }

    struct Photos: Codable {
        var photos: [String]
    }
    
    func getFirstPhoto(id: String) -> String {
        getPhotos(id: id)
        return photos[0]
    }
}
    
    var body: some View {
        return EmptyView()
    }

extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        let end = index(start, offsetBy: min(self.count - range.lowerBound,
                                             range.upperBound - range.lowerBound))
        return String(self[start..<end])
    }

    subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
         return String(self[start...])
    }
}


struct SearchResultsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsView()
    }
}
