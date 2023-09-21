//
//  SearchView-ViewModel.swift
//  Reciplease
//
//  Created by Hugues Fils on 19/04/2023.
//

import Foundation

@MainActor class SearchViewModel: ObservableObject {
    let service: ApiService
    
    init(service: ApiService = ApiService()) {
        self.service = service
    }
    
    @Published var ingredients = [String]()
    @Published var searchInput = ""
    @Published var isLoading = false
    @Published var results = [RecipeViewModel]()
    
    func addIngredient() {
        let newIngredient = searchInput.lowercased()
        if (searchInput != "" && !ingredients.contains(newIngredient)) {
            ingredients.insert(newIngredient, at: 0)
        }
    }
    
    func clearIngredients() {
        ingredients.removeAll()
    }
    
    func search() async {
        defer {
            isLoading = false
        }
        do {
            isLoading = true
            var tempResults = try await service.loadData(ingredients: ingredients)
            results = tempResults.map{ $0.self }
        } catch {
            print("Error loading data")
        }
    }
}

