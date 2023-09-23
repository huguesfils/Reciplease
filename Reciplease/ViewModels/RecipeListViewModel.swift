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
    
    private var favorites: [FavRecipe] = []
    
    init(_ recipes: [Recipe]) {
        self.recipesViewModel = recipes.map { RecipeViewModel(recipe: $0) }
    }
    
    init(_ favorites: [FavRecipe]) {
        self.recipesViewModel = favorites.map { RecipeViewModel(recipe: $0) }
    }
}
