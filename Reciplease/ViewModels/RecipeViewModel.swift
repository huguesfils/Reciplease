//
//  RecipeViewModel.swift
//  Reciplease
//
//  Created by Hugues Fils on 04/10/2023.
//

import Foundation
import CoreData

class RecipeViewModel: ObservableObject {
    @Published var isFavorite = Bool()
    
    var dataController: DataController
    
    var favorites = [FavRecipe]()
    
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
    var storedImage: Data {
        return recipe.storedImageValue
    }
    
    func addFavorite(recipe: Recipe) {
        do {
            try dataController.addToFavorite(recipe: recipe) {}
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func removeFavorite(recipe: Recipe) {
        dataController.fetchFavorite(url: recipe.url) { recipe in
            guard let recipe = recipe else { return }
            
            do {
                try dataController.removeFromFavorite(recipe: recipe)
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func checkIfRecipeIsFavorite() {
        dataController.isFavorite(recipe: recipe as! Recipe) { favorite in
            guard let favorite = favorite else {
                return
            }
            if favorite {
                isFavorite = true
            } else {
                isFavorite = false
            }
        }
    }
    
    func fetchFavorites() {
        dataController.fetchFavorites { favorites in
            self.favorites = favorites
            print("favoris: ", favorites.count)
        }
    }
    
}