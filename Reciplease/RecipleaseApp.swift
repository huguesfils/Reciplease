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
    
    let dataController = DataController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
