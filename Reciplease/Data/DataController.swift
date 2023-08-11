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
    static var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Reciplease")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    private let context = container.viewContext
    
    func addFavorite(label: String, image: String, ingredientLines: [String], url: String, totalTime: Int, foodIngredients: [String], completionHandler: @escaping () -> ()) {
        downloadImage(imageUrl: image) { data in
            let favRecipe = FavRecipe(context: self.context)
            favRecipe.storedImage = data?.image?.pngData()
            favRecipe.label = label
            favRecipe.image = image
            favRecipe.ingredientLines = ingredientLines
            favRecipe.foodIngredients = foodIngredients
            favRecipe.url = url
            favRecipe.totalTime = Int64(totalTime)
            do {
                try self.context.save()
                completionHandler()
            } catch let error{
                print("Error adding recipe to favorites: \(error)")
            }
        }
    }
    
    func removeFavorite(recipe: FavRecipe) {
        context.delete(recipe)
        do {
            try context.save()
        } catch let error {
            print("Error deleting item: \(error)")
        }
    }
    
    func downloadImage(imageUrl: String, completionHandler: @escaping (Data?) -> ()) {
        DispatchQueue.global().async {
            guard let imageUrl = URL(string: imageUrl) else {
                return DispatchQueue.main.async {
                    completionHandler(nil)
                }
            }
            do {
                let data = try Data(contentsOf: imageUrl)
                DispatchQueue.main.async {
                    completionHandler(data)
                }
            } catch {
                print("Error in download of image \(error)")
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            }
        }
    }
}

extension Data {
    var image: UIImage? {
        return UIImage(data: self)
    }
}
