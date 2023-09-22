//
//  RecipeViewModel.swift
//  Reciplease
//
//  Created by Hugues Fils on 19/09/2023.
//

import Foundation
import CoreData

@MainActor class RecipeViewModel: ObservableObject {
    @Published var favorites: [FavRecipe] = []
    
    var dataController: DataController
    
    let recipe: any RecipeProtocol
    
    init(dataController: DataController = .shared, recipe: any RecipeProtocol) {
        self.dataController = dataController
        self.recipe = recipe
    }
    
    var title: String {
        return recipe.labelValue
    }
    var image: String {
        return recipe.imageValue
    }
    var ingredientLines: [String] {
        return recipe.ingredientLinesValue
    }
    var ingredients: [String] {
        return recipe.foodIngredientsValue
    }
    var url: String {
        return recipe.urlValue
    }
    var totalTime: Int {
        return recipe.totalTimeValue
    }
    
    func fetchFavorites() {
        let fetchRequest = NSFetchRequest<FavRecipe>(entityName: "FavRecipe")
        
        do {
            favorites = try dataController.container.viewContext.fetch(fetchRequest)
        } catch let error {
            print("Failed to fetch favorites: \(error)")
        }
    }
}

