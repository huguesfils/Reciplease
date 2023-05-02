//
//  SearchView-ViewModel.swift
//  Reciplease
//
//  Created by Hugues Fils on 19/04/2023.
//

import Foundation

extension SearchView {
    @MainActor class ViewModel: ObservableObject {
//        @Published var ingredients = [String]()
        @Published var ingredients = ["cheese", "pork", "salad"]
        @Published var searchInput = ""
        @Published var isNavigate = false
        @Published var results = [Recipe]()
        
        let api_id = "c39bf8a9"
        let api_key = "eeacf7dbdf9f33c8887e9db29c640a16"
        
        func addIngredient() {
            let newIngredient = searchInput.lowercased()
            ingredients.insert(newIngredient, at: 0)
        }
        
//        func search() async -> [String] {
//            return ["toto", "titi"]
//        }
        
//        func recipiesListViewModel() async -> RecipiesListView.ViewModel {
//            let url = URL(string: "https://api.edamam.com/search?q=\(ingredients.joined(","))&app_id=\(api_id)&app_key=\(api_key)")
//            let (data, _) = try await URLSession.shared.data(from: url!)
//            let decoder = JSONDecoder()
//            let decodedResponse = try! decoder.decode(Response.self, from: data)
//            let recipes = (decodedResponse.hits ?? []).map { hit in
//                hit.recipe
//            }
//            return RecipiesListView.ViewModel(ingredients: ingredients)
//        }
        
        func loadData() async {
            guard let url = URL(string: "https://api.edamam.com/search?q=\(ingredients.joined(separator: ","))&app_id=\(api_id)&app_key=\(api_key)") else {
                print("Invalid URL")
                return
            }

            do {
                let (data, _) = try await URLSession.shared.data(from: url)

                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                     results = (decodedResponse.hits ?? []).map { hit in
                                         hit.recipe
                    }
                }
            } catch {
                print("Invalid data")
            }
       }
    }
    
    struct Response: Codable {
        var hits: [Hit]?
    }
    
    struct Hit: Codable {
        var recipe: Recipe
    }
    
    struct Recipe: Codable {
        var label: String
    }
}
