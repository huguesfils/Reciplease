//
//  RecipeViewModel.swift
//  Reciplease
//
//  Created by Hugues Fils on 04/10/2023.
//

import Foundation
import CoreData

class RecipeViewModel: ObservableObject {
    var dataController: DataController
    
    let recipe: any RecipeProtocol
    
    init(dataController: DataController = .shared, recipe: any RecipeProtocol) {
        self.dataController = dataController
        self.recipe = recipe
    }
    
    var id: String {
        return recipe.urlValue
    }
    var label: String {
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
    
    func addFavorite(recipe: Recipe) {
        do {
            try dataController.addToFavorite(recipe: recipe)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func removeFavorite(recipe: FavRecipe) {
        dataController.fetchFavorite(url: recipe.url!) { recipe in
            guard let recipe = recipe else { return }
            
            do {
                try dataController.removeFromFavorite(recipe: recipe)
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
}
