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
    
    var isComingFromFavoriteList: Bool
    var recipe: any RecipeProtocol
    
    private var dataController: DataController

    init(dataController: DataController = .shared, recipe: any RecipeProtocol) {
        self.dataController = dataController
        self.recipe = recipe
        self.isComingFromFavoriteList = self.recipe is FavRecipe
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
            try dataController.addToFavorite(recipe: recipe) { [weak self] in
                self?.checkIfRecipeIsFavorite()
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func removeFavorite() {
        defer {
            checkIfRecipeIsFavorite()
        }
        
        dataController.fetchFavorite(url: recipe.urlValue) { recipe in
            guard let recipe = recipe else { return }
            
            do {
                try dataController.removeFromFavorite(recipe: recipe)
                
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func checkIfRecipeIsFavorite() {
        dataController.isFavorite(recipe: recipe ) { favorite in
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
}
