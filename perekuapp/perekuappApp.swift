//
//  perekuappApp.swift
//  perekuapp
//
//  Created by Ievgenii Podovinnikov on 24.09.2022.
//

import SwiftUI

@main
struct perekuappApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
