//
//  SearchView-ViewModel.swift
//  Reciplease
//
//  Created by Hugues Fils on 19/04/2023.
//

import Foundation

extension SearchView {
    @MainActor class ViewModel: ObservableObject {
        @Published var ingredients = [String]()
        @Published var searchInput = ""
        @Published var isNavigate = false
        
        func addIngredient() {
            let newIngredient = searchInput.lowercased()
            ingredients.insert(newIngredient, at: 0)
        }
    }
}
