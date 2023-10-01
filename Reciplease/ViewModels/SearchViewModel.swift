//
//  SearchViewModel.swift
//  Reciplease
//
//  Created by Hugues Fils on 19/04/2023.
//

import Foundation

@MainActor class SearchViewModel: ObservableObject {
    @Published var ingredients = [String]()
    @Published var searchInput = ""
    @Published var isLoading = false
    
    private var recipes: [Recipe] = []
    var from = 0
    var to : Int = 10
    
    var recipeListViewModel: RecipeListViewModel {
        return RecipeListViewModel(recipes)
    }
    
    let service: ApiService
    
    init(service: ApiService = ApiService()) {
        self.service = service
    }
    
    func addIngredient() {
        let newIngredient = searchInput.lowercased()
        if (searchInput != "" && !ingredients.contains(newIngredient)) {
            ingredients.insert(newIngredient, at: 0)
        }
    }
    
    func clearIngredients() {
        ingredients.removeAll()
    }
    
    func search() {
        defer {
            isLoading = true
        }
        service.loadData(ingredients: ingredients) { recipes, cases in
            switch cases {
            case .Success:
                guard let recipes = recipes else { return }
                self.recipes = []
                self.recipes = recipes
                self.isLoading = false
                print(recipes.count)
            case .WrongDataReceived:
                print(cases)
            case .HttpStatusCodeError:
                print(cases)
            case .Empty:
                print(cases)
            case .BadUrlForRequest:
                print(cases)
            }
        }
    }
    
//    func search() {
//        defer {
//            isLoading = false
//        }
//        do {
//            isLoading = true
//            recipes = try await service.loadData(ingredients: ingredients)
//            
//        } catch {
//            print("Error loading data")
//        }
//    }
    
    func loadMoreContent() {
        //        let lastCount = self.recipes.index(self.recipes.endIndex, offsetBy: -1)
        //        print(lastCount)
        //        if lastCount == item {
        from += 10
        to += 10
//        search(from: from, to: to)
    }
    
}
