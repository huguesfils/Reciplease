//
//  FavoritesViewModel.swift
//  Reciplease
//
//  Created by Hugues Fils on 06/10/2023.
//

import Foundation

class FavoriteViewModel: ObservableObject {
    @Published var recipesViewModel = [RecipeViewModel]()
    @Published var noFavorites = false
    
    var favorites = [FavRecipe]()
    
    private var dataController: DataController
    
    var recipiesListViewModel: RecipiesListViewModel {
        return RecipiesListViewModel(dataController)
    }
    
    init(dataController: DataController = .shared) {
        self.dataController = dataController
    }
    
    func fetchFavorites() {
        dataController.fetchFavorites { favorites in
            self.recipesViewModel = favorites.map { RecipeViewModel(recipe: $0) }
        }
    }
}

