//
//  DataController.swift
//  Reciplease
//
//  Created by Hugues Fils on 17/05/2023.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Reciplease")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data falied to load: \(error.localizedDescription)")
            }
        }
    }
}
