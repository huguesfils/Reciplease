//
//  FavoritesViewModel.swift
//  Reciplease
//
//  Created by Hugues Fils on 06/10/2023.
//

import Foundation

class FavoriteViewModel: ObservableObject {
    
    var favorites = [FavRecipe]()
    
    var dataController: DataController
    
    var recipiesListViewModel: RecipiesListViewModel {
        return RecipiesListViewModel(favorites)
    }
    
    init(dataController: DataController = .shared) {
        self.dataController = dataController
        fetchFavorites()
    }
    
    func fetchFavorites() {
        dataController.fetchFavorites { favorites in
            self.favorites = favorites
            print("favoris: ", favorites.count)
        }
    }
}

