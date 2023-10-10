//
//  FavoritesViewModel.swift
//  Reciplease
//
//  Created by Hugues Fils on 06/10/2023.
//

import Foundation

class FavoriteViewModel: ObservableObject {
    var favorites = [FavRecipe]()
    @Published var hasFavorites: Bool = false
    
    private var dataController: DataController
    
    var recipiesListViewModel: RecipiesListViewModel {
        return RecipiesListViewModel(dataController)
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
//        dataController.hasFavorites { hasFav in
//            hasFavorites = hasFav
//        }
    }
}

