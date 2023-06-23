//
//  DataController.swift
//  Reciplease
//
//  Created by Hugues Fils on 17/05/2023.
//

import CoreData
import Foundation
import SwiftUI

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
    
    
   
    func removeFavorite(recipe: FavRecipe, context: NSManagedObjectContext) {
        context.delete(recipe)
        save(context: context)
    }
    
    func convertToImage(url: String) {
       
    }
}

extension DataController {
    func addFavorite(label: String, image: String, ingredientLines: [String], url: String, totalTime: Int, context: NSManagedObjectContext) {
        let favRecipe = FavRecipe(context: context)
        let imageUrl = URL(string: image)!
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: imageUrl) {
                DispatchQueue.main.async {
                    favRecipe.storedImage = UIImage(data: data)?.pngData()
                }
            }
        }
        favRecipe.label = label
        favRecipe.image = image
        favRecipe.ingredientLines = ingredientLines
        favRecipe.url = url
        favRecipe.totalTime = Int64(totalTime)
        save(context: context)
    }
}
