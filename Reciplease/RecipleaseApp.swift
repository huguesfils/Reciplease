//
//  RecipleaseApp.swift
//  Reciplease
//
//  Created by Hugues Fils on 11/04/2023.
//

import SwiftUI

@main
struct RecipleaseApp: App {
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, CoreDataStack.shared.mainContext)
        }
        .onChange(of: scenePhase) { _ in
            CoreDataStack.shared.saveContext()
        }
    }
}
