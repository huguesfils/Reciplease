//
//  DataController.swift
//  Reciplease
//
//  Created by Hugues Fils on 06/10/2023.
//

import Foundation
import CoreData
import SwiftUI

class DataController: ObservableObject {
    
    static let shared = DataController()
    
    let mainContext: NSManagedObjectContext
    
    init(mainContext: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.mainContext = mainContext
    }
    
    func addToFavorite(recipe: Recipe, completionHandler: @escaping () -> ()) throws {
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
                print("Error adding recipe to favorites: \(error.localizedDescription)")
            }
        }
    }
    
    func removeFromFavorite(recipe: FavRecipe) throws {
            do {
                mainContext.delete(recipe)
                try mainContext.save()
            } catch let error{
                print("Error deleting recipe from favorites: \(error.localizedDescription)")
        }
    }
    
    func fetchFavorites(completion: ([FavRecipe]) -> Void) {
        let request: NSFetchRequest<FavRecipe> = FavRecipe.fetchRequest()

            do {
                let recipes = try mainContext.fetch(request)
                completion(recipes)
            } catch let error{
                print("Error fetching favorites: \(error.localizedDescription)")
            }
    }
    
    func fetchFavorite(url: String, completion: (FavRecipe?) -> Void) {
        let request: NSFetchRequest<FavRecipe> = FavRecipe.fetchRequest()
        request.predicate = NSPredicate(format: "url == %@", url)

            do {
                guard let recipe = try mainContext.fetch(request).first else {
                    completion(nil)
                    return
                }
                
                completion(recipe)
                
            } catch let error{
                print("Error fetching favorite: \(error.localizedDescription)")
            }
    }
    
    func isFavorite(recipe: any RecipeProtocol, completion : (Bool?) -> Void) {
            let request : NSFetchRequest<FavRecipe> = FavRecipe.fetchRequest()
            request.predicate = NSPredicate(format: "url == %@", recipe.urlValue)
            do {
                guard let _ = try mainContext.fetch(request).first else {
                    completion(false)
                    return
                }
                completion(true)
            } catch let error {
                print("Error checking if recipe is favorite : \(error.localizedDescription)")
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
                print("Error in download of image \(error.localizedDescription)")
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
