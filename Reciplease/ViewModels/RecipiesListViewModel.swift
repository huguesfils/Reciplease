//
//  RecipiesListViewModel.swift
//  Reciplease
//
//  Created by Hugues Fils on 04/10/2023.
//

import Foundation

class RecipiesListViewModel: ObservableObject {
    @Published var isLoading = Bool()
    @Published var recipesViewModel = [RecipeViewModel]()

    private var ingredients: [String]?
    private let service = Service()
    
    init(_ ingredients: [String]) {
        self.ingredients = ingredients
        service.loadData(ingredients: ingredients) { recipes, nextPage, cases in
            switch cases {
            case .Success:
                guard let recipes = recipes else { return }
                self.isLoading = false
                self.recipesViewModel = recipes.map { RecipeViewModel(recipe: $0) }
            case .WrongDataReceived:
                //                alerte
                return
            case .BadUrlForRequest:
                //                alerte
                return
            case .HttpStatusCodeError:
                //                alerte
                return
            case .Empty:
                //                salerte
                return
            }
        }
    }
    
    init(_ favorites: [FavRecipe]) {
        self.recipesViewModel = favorites.map { RecipeViewModel(recipe: $0) }
        print("list: ",favorites.count)
    }
}
