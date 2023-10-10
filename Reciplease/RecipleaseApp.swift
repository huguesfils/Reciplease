//
//  RecipleaseApp.swift
//  Reciplease
//
//  Created by Hugues Fils on 04/10/2023.
//

import SwiftUI

@main
struct RecipleaseApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, CoreDataStack.shared.mainContext)
        }
    }
}
