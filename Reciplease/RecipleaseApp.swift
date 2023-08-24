//
//  RecipleaseApp.swift
//  Reciplease
//
//  Created by Hugues Fils on 11/04/2023.
//

import SwiftUI

@main
struct RecipleaseApp: App {
    @StateObject private var dataController = DataController(errorCd: "")
    
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, DataController.container.viewContext)
        }
    }
}
