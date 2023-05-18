//
//  SearchView-ViewModel.swift
//  Reciplease
//
//  Created by Hugues Fils on 19/04/2023.
//

import Foundation
import SwiftUI

extension SearchView {
    @MainActor class ViewModel: ObservableObject {
        let service: RecipeService
        
        init(service: RecipeService = RecipeService()) {
            self.service = service
        }
        
        @Published var ingredients = [String]()
        @Published var searchInput = ""
        
        @Published var isLoading = false
        @Published var results = [Recipe]()
        
        func addIngredient() {
            let newIngredient = searchInput.lowercased()
            if (searchInput != "" && !ingredients.contains(newIngredient)) {
                ingredients.insert(newIngredient, at: 0)
                print(ingredients)
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
                results = try await service.loadData(ingredients: ingredients)
            } catch {
                print("Error loading data")
            }
        }
    }
}
