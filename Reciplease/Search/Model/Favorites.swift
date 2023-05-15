//
//  Favorites.swift
//  Reciplease
//
//  Created by Hugues Fils on 12/05/2023.
//

import Foundation

class Favorites: ObservableObject {
    private var favoriteRecipes = [Recipe]()
    private let saveKey = "Favorites"
    

    func add(recipe: Recipe) {
        favoriteRecipes.append(recipe)
        print(favoriteRecipes)
       
    }
    
//    func remove(recipe: Recipe) {
//       let index = recipe
//        favoriteRecipes.remove(at: recipe)
//        print(favoriteRecipes)
//    }
    
  
}
