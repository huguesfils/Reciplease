//
//  SearchViewModel.swift
//  Reciplease
//
//  Created by Hugues Fils on 04/10/2023.
//

import Foundation

class SearchViewModel: ObservableObject {
    @Published var ingredients: [Ingredient] = []

    @Published var searchInput = ""

    struct Ingredient: Identifiable {
        let id: UUID = UUID()
        let name: String
    }

    func addIngredient() {
        let newIngredient = searchInput.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if (searchInput != "" && !ingredients.contains(where: {$0.name == newIngredient})) {
            let ingredient = Ingredient(name: newIngredient)
            ingredients.insert(ingredient, at: 0)
        }
    }

    func removeIngredient(id: UUID) {
        ingredients.removeAll { $0.id == id }
    }

    func clearIngredients() {
        ingredients.removeAll()
    }

    func toRecipeListViewModel() -> RecipiesListViewModel {
        let ingredientNames = ingredients.map { $0.name }
        return RecipiesListViewModel(ingredientNames)
    }
}
