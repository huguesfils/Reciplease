//
//  Favorite-ViewModel.swift
//  Reciplease
//
//  Created by Hugues Fils on 21/09/2023.
//

import Foundation
import CoreData

@MainActor class FavoriteViewModel: ObservableObject {
    private var favorites: [FavRecipe] = []
    @Published var isEmpty: Bool = false
    let dataController: DataController
    
    init(dataController: DataController = DataController()) {
        self.dataController = dataController
    }
    
    var recipeListViewModel: RecipeListViewModel {
        return RecipeListViewModel(favorites)
    }
    
    func fetchFavorites() {
        let fetchRequest = NSFetchRequest<FavRecipe>(entityName: "FavRecipe")
        
        do {
            favorites = try dataController.container.viewContext.fetch(fetchRequest)
            
            self.isEmpty = favorites.isEmpty
            
        } catch let error {
            print("Failed to fetch favorites: \(error)")
        }
        
    }
}
