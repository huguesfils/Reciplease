//
//  RecipeModel.swift
//  Reciplease
//
//  Created by Hugues Fils on 09/05/2023.
//

import Foundation

let api_id = "c39bf8a9"
let api_key = "eeacf7dbdf9f33c8887e9db29c640a16"

struct Response: Codable {
    var hits: [Hit]?
}

struct Hit: Codable {
    var recipe: Recipe
}

struct Recipe: Codable {
//    var uri: String
    var label: String
    var image: String
    var ingredientLines: [String]
    var url: String
}

struct RecipeService {
    func loadData(ingredients: [String]) async throws  -> [Recipe] {
        guard let url = URL(string: "https://api.edamam.com/search?q=\(ingredients.joined(separator: ","))&app_id=\(api_id)&app_key=\(api_key)") else {
            print("Invalid URL")
            return []
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                return (decodedResponse.hits ?? []).map { hit in
                    hit.recipe
                }
            } else {
                return []
            }
        } catch {
            print("Invalid data")
            return []
        }
    }
    
}
