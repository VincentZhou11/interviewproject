//
//  DevInterviewAppApp.swift
//  DevInterviewApp
//
//  Created by Vincent Zhou on 9/15/22.
//

import SwiftUI

@main
struct DevInterviewAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView(viewContext: persistenceController.container.viewContext)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
