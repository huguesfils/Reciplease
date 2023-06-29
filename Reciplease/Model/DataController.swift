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
                print("Core Data falied to load: \(error.localizedDescription)")
            }
        }
        return container
    }()

    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("Data not saved, error: \(error)")
        }
    }
    
    func addFavorite(label: String, image: String, ingredientLines: [String], url: String, totalTime: Int, context: NSManagedObjectContext) {
        downloadImage(imageUrl: image) { data in
            let favRecipe = FavRecipe(context: context)
            favRecipe.storedImage = data?.image?.pngData()
            favRecipe.label = label
            favRecipe.image = image
            favRecipe.ingredientLines = ingredientLines
            favRecipe.url = url
            favRecipe.totalTime = Int16(totalTime)
            self.save(context: context)
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
    
    func removeFavorite(recipe: FavRecipe, context: NSManagedObjectContext) {
        context.delete(recipe)
        save(context: context)
    }
}

extension Data {
    var image: UIImage? {
        return UIImage(data: self)
    }
}
