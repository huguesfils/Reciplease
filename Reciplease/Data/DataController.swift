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
    
    @Published var hasError: Bool = false
    @Published private(set) var errorCd: String
    
    
     static var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Reciplease")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        return container
    }()

    private let mainContext: NSManagedObjectContext
    
    init(mainContext: NSManagedObjectContext = container.viewContext, errorCd: String) {
        self.mainContext = mainContext
        self.errorCd = errorCd
    }
    
    func addFavorite(label: String, image: String, ingredientLines: [String], url: String, totalTime: Int, foodIngredients: [String], completionHandler: @escaping () -> ()) {
        downloadImage(imageUrl: image) { data in
            let favRecipe = FavRecipe(context: self.mainContext)
            favRecipe.storedImage = data?.image?.pngData()
            favRecipe.label = label
            favRecipe.image = image
            favRecipe.ingredientLines = ingredientLines
            favRecipe.foodIngredients = foodIngredients
            favRecipe.url = url
            favRecipe.totalTime = Int64(totalTime)
            do {
                try self.mainContext.save()
                completionHandler()
            } catch let error{
                self.errorCd = error.localizedDescription
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
                self.errorCd = error.localizedDescription
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
            self.errorCd = error.localizedDescription
            self.hasError = true
            print("Error deleting item: \(error)")
        }
    }
}

extension Data {
    var image: UIImage? {
        return UIImage(data: self)
    }
}
