//
//  RecipeDetailViewModel.swift
//  Reciplease
//
//  Created by Hugues Fils on 02/10/2023.
//

import Foundation
import CoreData

class RecipeDetailViewModel: ObservableObject {
    @Published var favorites: [Recipe] = []
    @Published var isFavoriteRecipe = false
    var recipe: Recipe
    
    let dataController = DataController.shared
    
    init(recipe: Recipe) {
        self.recipe = recipe
        fetchFavorites()
    }
    
    func fetchFavorites() {
        let fetchRequest: NSFetchRequest<FavRecipe> = FavRecipe.fetchRequest()
            do {
                let results = try dataController.mainContext.fetch(fetchRequest)
                favorites = results.map { recipe in
                    Recipe(label: recipe.label ?? "",
                           image: recipe.image ?? "",
                           ingredientLines: recipe.ingredientLines ?? [],
                           ingredients: recipe.ingredients ?? [],
                           totalTime: Int(recipe.totalTime),
                           url: recipe.url ?? "")
                }
            } catch let error {
                print("Failed to fetch favorites: \(error)")
            }
        }
    
    func addFavorite(recipe: Recipe) {
        dataController.addFavorite(recipe: recipe)
        favorites.append(recipe)
    }
    
    func removeFavorite(recipe: Recipe) {
        dataController.removeFavorite(label: recipe.label)
        favorites.removeAll { $0.label == recipe.label }
    }
    
    func toggleFavorite(recipe: Recipe)  {
        if isRecipeFavorite(recipe: recipe) {
            removeFavorite(recipe: recipe)
            
        } else {
            addFavorite(recipe: recipe)
        }
    }
    
    func isRecipeFavorite(recipe: Recipe) -> Bool {
        return favorites.contains { $0.label == recipe.label }
    }
    
//    func toggleFavorite(recipe: Recipe)  {
//        if isRecipeFavorite(recipe: recipe) {
//            deleteRecipeFromFavorite(recipe: recipe)
//            
//        } else {
//            addRecipeToFavorite(recipe: recipe)
//        }
//    }
}
