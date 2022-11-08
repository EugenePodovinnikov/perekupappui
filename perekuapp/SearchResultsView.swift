//
//  SearchResultsView.swift
//  perekuapp
//
//  Created by Ievgenii Podovinnikov on 14.10.2022.
//

import SwiftUI

struct SearchResultsView: View {
    var body: some View {
        ZStack {
            Image("porsche911").resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct SearchResultsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsView()
    }
}
