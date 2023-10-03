//
//  SearchViewModel.swift
//  Reciplease
//
//  Created by Hugues Fils on 19/04/2023.
//

import Foundation

class SearchViewModel: ObservableObject {
    
    @Published var ingredients = [String]()
    @Published var searchInput = ""
    
    func addIngredient() {
        let newIngredient = searchInput.lowercased()
        if (searchInput != "" && !ingredients.contains(newIngredient)) {
            ingredients.insert(newIngredient, at: 0)
        }
    }
    
    func clearIngredients() {
        ingredients.removeAll()
    }
    
    func toRecipeListViewModel() -> RecipeListViewModel {
        return RecipeListViewModel(fromIngredients: ingredients)
    }
}
