//
//  SearchResultsView.swift
//  perekuapp
//
//  Created by Ievgenii Podovinnikov on 14.10.2022.
//

import SwiftUI


struct SearchResultsView: View {
    
    var searchResults: [MainPageView.SingleResult]
    @State var photos = [Photo]()
    
    init() {
        self.searchResults = [MainPageView.SingleResult]()
    }
    
    init(searchResults: [MainPageView.SingleResult]) {
        self.searchResults = searchResults
    }
    
    func getPhotos(id: String) {
        let urlString = photosUrl + id
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
        photos = try! decoder.decode([Photo].self, from: json) as! [Photo]
    }

    
    var body: some View {
        ZStack {
            Image("aventador").resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            VStack {
                ScrollView {
                    ForEach(searchResults) { searchResult in
                        Section {
                            Text("""
                                \(searchResult.title)\n
                                \(searchResult.locationCityName)\n
                                $ \(searchResult.USD)
                                """).padding(30).foregroundColor(Color.white).background(Color.purple).cornerRadius(20).frame(maxWidth: .infinity)
                            Link("Смотреть",
                                 destination: URL(string: searchResult.linkToView)!).background( Color.green).foregroundColor(Color.white).padding(30).cornerRadius(15)
                        }
                    }
                }
            }
        }
    }
}

struct Photos: Codable, Identifiable {
    let id = UUID()
    var photos: [Photo]
}

struct Photo: Codable {
    var photo: String
}

struct SearchResultsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsView()
    }
}
