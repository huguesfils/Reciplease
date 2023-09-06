//
//  FavoritesView-ViewModel.swift
//  Reciplease
//
//  Created by Hugues Fils on 06/09/2023.
//

import Foundation
import CoreData


@MainActor class FavoritesViewModel: ObservableObject {
    @Published var favorites: [FavRecipe] = []
    
    let mainContext: NSManagedObjectContext
    
    init(mainContext: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.mainContext = mainContext
        fetch()
    }
    
    func fetch() {
        let fetchRequest = NSFetchRequest<FavRecipe>(entityName: "FavRecipe")
        
        mainContext.performAndWait {
            do {
                favorites = try mainContext.fetch(fetchRequest)
            } catch let error {
                print("Failed to fetch favRecipes: \(error)")
            }
        }
    }
    
    
}

