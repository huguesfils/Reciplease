//
//  Favorites.swift
//  Reciplease
//
//  Created by Hugues Fils on 12/05/2023.
//

import Foundation

class Favorites: ObservableObject {
    private var favoriteRecipes: Set<String>
    private let saveKey = "Favorites"
    
    init() {
        favoriteRecipes = []
    }
    
    func contains(_ recipe: Recipe) -> Bool {
        favoriteRecipes.contains(recipe.label)
    }
    
    func add(_ recipe: Recipe) {
        objectWillChange.send()
        favoriteRecipes.insert(recipe.label)
        print(favoriteRecipes)
        save()
    }
    
    func remove(_ recipe: Recipe) {
        objectWillChange.send()
        favoriteRecipes.remove(recipe.label)
        print(favoriteRecipes)
        save()
    }
    
    func save() {
        //data
    }
}
