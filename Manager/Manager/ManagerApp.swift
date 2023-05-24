//
//  ManagerApp.swift
//  Manager
//
//  Created by Rita Marrano on 24/05/23.
//

import SwiftUI

@main
struct ManagerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
