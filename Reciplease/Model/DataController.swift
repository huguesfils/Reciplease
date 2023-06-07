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
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Data saved!")
        } catch {
            print("Data not saved")
        }
    }
    
    func addFavorite(label: String, image: String, ingredientLines: [String], url: String, totalTime: Int, context: NSManagedObjectContext) {
        let favRecipe = FavRecipe(context: context)
        favRecipe.label = label
        favRecipe.image = image
        favRecipe.ingredientLines = ingredientLines
        favRecipe.url = url
        favRecipe.totalTime = Int64(totalTime)
        
        save(context: context)
    }
   
    func removeFavorite(recipe: FavRecipe, context: NSManagedObjectContext) {
        context.delete(recipe)
        save(context: context)
    }
}
