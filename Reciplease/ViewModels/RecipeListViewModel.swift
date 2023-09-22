//
//  RecipeListViewModel.swift
//  Reciplease
//
//  Created by Hugues Fils on 21/09/2023.
//

import Foundation
import CoreData

@MainActor class RecipeListViewModel: ObservableObject {
    @Published var recipesViewModel: [RecipeViewModel]
    
    let dataController: DataController
    
    private var favorites: [FavRecipe] = []
    
    init(_ recipes: [Recipe], dataController: DataController = DataController()) {
        self.recipesViewModel = recipes.map { RecipeViewModel(recipe: $0) }
        self.dataController = dataController
    }
    
    init(_ favorites: [FavRecipe], dataController: DataController = DataController()) {
        self.recipesViewModel = favorites.map { RecipeViewModel(recipe: $0) }
        self.dataController = dataController
    }

//    init( dataController: DataController = DataController()) {
//        self.dataController = dataController
//    }
    
    func fetchFavorites() {
        let fetchRequest = NSFetchRequest<FavRecipe>(entityName: "FavRecipe")
        
        do {
            favorites = try dataController.container.viewContext.fetch(fetchRequest)
    
        } catch let error {
            print("Failed to fetch favorites: \(error)")
        }
        
    }
}
