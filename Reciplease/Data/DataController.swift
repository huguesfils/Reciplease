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
    @Published private(set) var errorCoreData: String
    @Published var hasError: Bool = false
    
    let backgroundcontext: NSManagedObjectContext
    let mainContext: NSManagedObjectContext
    
    init(mainContext: NSManagedObjectContext = CoreDataStack.shared.mainContext,
         backgroundContext: NSManagedObjectContext = CoreDataStack.shared.backgroundContext, errorCoreData: String) {
        self.errorCoreData = errorCoreData
        self.mainContext = mainContext
        self.backgroundcontext = backgroundContext
    }
    
    
    func addFavorite(label: String, image: String, ingredientLines: [String], url: String, totalTime: Int, foodIngredients: [String], completionHandler: @escaping () -> ()) {
        backgroundcontext.performAndWait {
            downloadImage(imageUrl: image) { data in
                let favRecipe = NSEntityDescription.insertNewObject(forEntityName: "FavRecipe", into: self.backgroundcontext) as! FavRecipe
                favRecipe.storedImage = data?.image?.pngData()
                favRecipe.label = label
                favRecipe.image = image
                favRecipe.ingredientLines = ingredientLines
                favRecipe.foodIngredients = foodIngredients
                favRecipe.url = url
                favRecipe.totalTime = Int64(totalTime)
                do {
                    try self.backgroundcontext.save()
                    completionHandler()
                } catch let error{
                    self.errorCoreData = error.localizedDescription
                    self.hasError = true
                    print("Error adding recipe to favorites: \(error)")
                }
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
    
    func removeFavorite(favRecipe: FavRecipe) {
        let objectID = favRecipe.objectID
        backgroundcontext.performAndWait {
            do {
                if let favRecipeInContext = try? backgroundcontext.existingObject(with: objectID) {
                    backgroundcontext.delete(favRecipeInContext)
                    try backgroundcontext.save()
                }
            } catch let error{
                self.errorCoreData = error.localizedDescription
                self.hasError = true
                print("Error deleting item: \(error)")
            }
            
        }
    }
    
    func fetch() -> [FavRecipe]? {
        let fetchRequest = NSFetchRequest<FavRecipe>(entityName: "FavRecipe")
        
        var favRecipes: [FavRecipe]?
        
        mainContext.performAndWait {
            do {
                favRecipes = try mainContext.fetch(fetchRequest)
            } catch let error {
                print("Failed to fetch favRecipes: \(error)")
            }
        }
        return favRecipes
    }
    
    
    
    //    @Published var hasError: Bool = false
    //    @Published private(set) var errorCd: String
    //
    //     static var container: NSPersistentContainer = {
    //        let container = NSPersistentContainer(name: "Reciplease")
    //        container.loadPersistentStores { description, error in
    //            if let error = error {
    //                print("Core Data failed to load: \(error.localizedDescription)")
    //            }
    //        }
    //        return container
    //    }()
    //
    //    private let mainContext: NSManagedObjectContext
    //
    //    init(mainContext: NSManagedObjectContext = container.viewContext, errorCd: String) {
    //        self.mainContext = mainContext
    //        self.errorCd = errorCd
    //    }
    //
    //    func addFavorite(label: String, image: String, ingredientLines: [String], url: String, totalTime: Int, foodIngredients: [String], completionHandler: @escaping () -> ()) {
    //        downloadImage(imageUrl: image) { data in
    //            let favRecipe = FavRecipe(context: self.mainContext)
    //            favRecipe.storedImage = data?.image?.pngData()
    //            favRecipe.label = label
    //            favRecipe.image = image
    //            favRecipe.ingredientLines = ingredientLines
    //            favRecipe.foodIngredients = foodIngredients
    //            favRecipe.url = url
    //            favRecipe.totalTime = Int64(totalTime)
    //            do {
    //                try self.mainContext.save()
    //                completionHandler()
    //            } catch let error{
    //                self.errorCd = error.localizedDescription
    //                self.hasError = true
    //                print("Error adding recipe to favorites: \(error)")
    //            }
    //        }
    //    }
    //
    
    //
    //    func removeFavorite(recipe: FavRecipe) {
    //        mainContext.delete(recipe)
    //        do {
    //            try mainContext.save()
    //        } catch let error {
    //            self.errorCd = error.localizedDescription
    //            self.hasError = true
    //            print("Error deleting item: \(error)")
    //        }
    //    }
    //
    //    private func fetch() -> [FavRecipe]? {
    //        let fetchRequest = NSFetchRequest<FavRecipe>(entityName: "FavRecipe")
    //        do {
    //            let favRecipes = try mainContext.fetch(fetchRequest)
    //            return favRecipes
    //        } catch let error {
    //            print("Failed to fetch favRecipes: \(error)")
    //        }
    //        return nil
    //    }
}

extension Data {
    var image: UIImage? {
        return UIImage(data: self)
    }
}
