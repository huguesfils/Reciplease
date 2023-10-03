//
//  RecipeListViewModel.swift
//  Reciplease
//
//  Created by Hugues Fils on 21/09/2023.
//

import Foundation
import CoreData

class RecipeListViewModel: ObservableObject {
    @Published var recipes = [Recipe]()
    @Published var isLoading = true
    
    private var ingredients: [String]?
    
    init(fromIngredients ingredients: [String]) {
        self.ingredients = ingredients
        service.loadData(viewModel: viewModel) { recipes, nextPage, cases in
            switch cases {
            case .Success:
                guard let recipes = recipes else { return }
                self.isLoading = false
                if let nextPage = nextPage {
                    self.nextPage = nextPage
                }
                self.recipes = recipes
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
        //self.recipesViewModel = favorites.map { RecipeViewModel(recipe: $0) }
    }
    
    var nextPage: Next?
    
    private let service = ApiService()
    
    func fetchRecipes(viewModel: SearchViewModel) {
        service.loadData(viewModel: viewModel) { recipes, nextPage, cases in
            switch cases {
            case .Success:
                guard let recipes = recipes else { return }
                self.isLoading = false
                if let nextPage = nextPage {
                    self.nextPage = nextPage
                }
                self.recipes = recipes
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
    
//    func getNextPage(nextPage: Next) {
//        service.getNextPage(nextPage: nextPage) { recipes, nextPage, cases in
//            switch cases {
//            case .Success:
//                guard let recipes = recipes else { return }
//                //                nextPage ?
//            case .WrongDataReceived:
//                //                alerte
//                return
//            case .BadUrlForRequest:
//                //                alerte
//                return
//            case .HttpStatusCodeError:
//                //                alerte
//                return
//            case .Empty:
//                //                salerte
//                return
//            }
//        }
//    }
    
    //    @Published var recipes: [RecipesResponse] = []
    //    @Published var isLoading = true
    
    //    @Published var recipesViewModel: [RecipeViewModel]
    //
    //    private var favorites: [FavRecipe] = []
    //
    //    init(_ recipes: [Recipe]) {
    //        self.recipesViewModel = recipes.map { RecipeViewModel(recipe: $0) }
    //    }
    //
    //    init(_ favorites: [FavRecipe]) {
    //        self.recipesViewModel = favorites.map { RecipeViewModel(recipe: $0) }
    //    }
    
    
}
