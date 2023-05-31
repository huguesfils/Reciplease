//
//  RecipeModel.swift
//  Reciplease
//
//  Created by Hugues Fils on 09/05/2023.
//

import Foundation

let api_id = "c39bf8a9"
let api_key = "eeacf7dbdf9f33c8887e9db29c640a16"

protocol RecipeProtocol {
    var labelValue: String { get }
    var urlValue: String { get }
    var imageValue: String { get }
    var totalTimeValue: Int { get }
    var ingredientLinesValue: [String] { get }
//    var foodsValue: [Food] { get }
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
    var ingredientLines: [String]
//    var ingredients: [Ingredient]
    var url: String
//    var foods: [Food]
    var totalTime: Int
}

//struct Ingredient: Codable {
//    var food: String
//}
//
//struct Food: Codable {
//    var food: String
//}

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

extension FavRecipe: RecipeProtocol {
    var imageValue: String {
        image ?? ""
    }
    var totalTimeValue: Int {
        0
    }
    var ingredientLinesValue: [String] {
        (ingredientLines ?? "").split(separator: "||").map { String($0) }
    }
//    var foodsValue: [Food] {
//        (foods ?? Food(food: "")).food.split(separator: "||").map {Food(food: String)($0)}
//    }
    var labelValue: String {
        label!
    }
    var urlValue: String {
        url ?? ""
    }
}

extension Recipe: RecipeProtocol {
    var imageValue: String {
        image
    }
    var totalTimeValue: Int {
        totalTime
    }
    var ingredientLinesValue: [String] {
        ingredientLines
    }
//    var foodsValue: [Food] {
//        foods
//    }
    var labelValue: String {
        label
    }
    var urlValue: String {
        url
    }
}

