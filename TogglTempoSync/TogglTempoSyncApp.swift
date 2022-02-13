//
//  TogglTempoSyncApp.swift
//  TogglTempoSync
//
//  Created by Carlos Silva on 02/02/2022.
//

import SwiftUI

@main
struct TogglTempoSyncApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
