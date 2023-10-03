//
//  FavoriteViewModel.swift
//  Reciplease
//
//  Created by Hugues Fils on 21/09/2023.
//

import Foundation
import CoreData

class FavoriteViewModel: ObservableObject {
    @Published var isEmpty: Bool = false
    @Published var favorites: [Recipe] = []
    
    init() {
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
    
    
//
//    init(dataController: DataController = DataController()) {
//        self.dataController = dataController
//    }
//    
    var recipeListViewModel: RecipeListViewModel {
        return RecipeListViewModel(favorites)
    }
//    
//    func fetchFavorites() {
//        let fetchRequest = NSFetchRequest<FavRecipe>(entityName: "FavRecipe")
//        
//        do {
//            favorites = try dataController.mainContext.fetch(fetchRequest)
//            print(favorites.count)
//            
//            self.isEmpty = favorites.isEmpty
//            print("is empty: ", favorites.isEmpty)
//            
//        } catch let error {
//            print("Failed to fetch favorites: \(error)")
//        }
//        
//    }
}
