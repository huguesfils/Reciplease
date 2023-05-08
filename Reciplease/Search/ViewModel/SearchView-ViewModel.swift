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
        @Published var ingredients = [String]()
        @Published var searchInput = ""
        @Published var results = [Recipe]()
        @Published var isLoading = false
        
        let api_id = "c39bf8a9"
        let api_key = "eeacf7dbdf9f33c8887e9db29c640a16"
        
        func addIngredient() {
            let newIngredient = searchInput.lowercased()
            ingredients.insert(newIngredient, at: 0)
            print(ingredients)
        }
        
        func loadData() async {
            
            print("1")
            guard let url = URL(string: "https://api.edamam.com/search?q=\(ingredients.joined(separator: ","))&app_id=\(api_id)&app_key=\(api_key)") else {
                print("Invalid URL")
                //revenir en arriere
                return
            }
            
            isLoading = true

            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                print("2")
                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                    print("3")
                    await MainActor.run {
                        print("4")
                        results = (decodedResponse.hits ?? []).map { hit in
                            hit.recipe
                        }
                        isLoading = false
                    }
                }
            } catch {
                //revenir en arriere
                print("Invalid data")
                isLoading = false
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
        var image: String
    }
}
