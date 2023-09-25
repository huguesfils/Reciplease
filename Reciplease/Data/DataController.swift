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
    @Published var errorCoreData: String = ""
    @Published var hasError: Bool = false
    
    static let shared = DataController()
    
    let mainContext: NSManagedObjectContext
    
    init(mainContext: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.mainContext = mainContext
    }
    
    func addFavorite(recipe: Recipe, completionHandler: @escaping () -> ()) {
        downloadImage(imageUrl: recipe.image) { data in
            let favRecipe = FavRecipe(context: self.mainContext)
            favRecipe.storedImage = data?.image?.pngData()
            favRecipe.label = recipe.label
            favRecipe.image = recipe.image
            favRecipe.ingredientLines = recipe.ingredientLines
            favRecipe.foodIngredients = recipe.foodIngredients
            favRecipe.url = recipe.url
            favRecipe.totalTime = Int64(recipe.totalTime)
            do {
                try self.mainContext.save()
                completionHandler()
            } catch let error{
                self.errorCoreData = error.localizedDescription
                self.hasError = true
                print("Error adding recipe to favorites: \(error)")
                
            }
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
            } catch let error{
                self.errorCoreData = error.localizedDescription
                self.hasError = true
                print("Error in download of image \(error)")
                DispatchQueue.main.async {
                    completionHandler(nil)
                }
            }
        }
    }
    
    func removeFavorite(recipe: FavRecipe) {
        mainContext.delete(recipe)
        do {
            try mainContext.save()
        } catch let error {
            self.errorCoreData = error.localizedDescription
            self.hasError = true
            print("Error deleting item: \(error)")
        }
    }
    
    func fetchFavorites() -> [FavRecipe]? {
        let fetchRequest = NSFetchRequest<FavRecipe>(entityName: "FavRecipe")
        
        var favRecipes: [FavRecipe]?
        
        do {
            favRecipes = try mainContext.fetch(fetchRequest)
        } catch let error {
            print("Failed to fetch favRecipes: \(error)")
        }
        
        return favRecipes
    }
}

extension Data {
    var image: UIImage? {
        return UIImage(data: self)
    }
}
