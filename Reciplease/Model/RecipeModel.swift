//
//  RecipeModel.swift
//  Reciplease
//
//  Created by Hugues Fils on 09/05/2023.
//

import Foundation
import SwiftUI

let api = ApiData()

protocol RecipeProtocol: Identifiable {
    associatedtype Id
    var id: Id { get }
    var labelValue: String { get }
    var urlValue: String { get }
    var imageValue: String { get }
    var totalTimeValue: Int { get }
    var ingredientLinesValue: [String] { get }
    //    var ingredientsValue: [String] { get }
    var storedImageValue: Data { get }
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
    //    var ingredients: [ingredient]
    var url: String
    var totalTime: Int
}

struct ingredient: Codable {
    var food: String
}

struct RecipeService {
    func loadData(ingredients: [String]) async throws  -> [Recipe] {
        guard let url = URL(string: "https://api.edamam.com/search?q=\(ingredients.joined(separator: ","))&app_id=\(api.api_id)&app_key=\(api.api_key)") else {
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

func calculateTime(_ timeValue: Int) -> String {
    let timeMeasure = Measurement(value: Double(timeValue), unit: UnitDuration.minutes)
    let hours = timeMeasure.converted(to: .hours)
    if hours.value > 1 {
        let minutes = timeMeasure.value.truncatingRemainder(dividingBy: 60)
        return String(format: "%.f %@ %.f %@", hours.value, "h", minutes, "min")
    }
    return String(format: "%.f %@", timeMeasure.value, "min")
}

extension FavRecipe: RecipeProtocol {
    public var id: String {
        return urlValue
    }
    var imageValue: String {
        image ?? ""
    }
    var totalTimeValue: Int {
        Int(totalTime)
    }
    var ingredientLinesValue: [String] {
        ingredientLines ?? []
    }
    var labelValue: String {
        label ?? ""
    }
    var urlValue: String {
        url ?? ""
    }
    var storedImageValue: Data {
        storedImage ?? Data()
    }
    //    var ingredientsValue: [String] {
    //        ingredients ?? [Any]
    //    }
}

extension Recipe: RecipeProtocol {
    var id: String {
        return urlValue
    }
    var imageValue: String {
        image
    }
    var totalTimeValue: Int {
        totalTime
    }
    var ingredientLinesValue: [String] {
        ingredientLines
    }
    var labelValue: String {
        label
    }
    var urlValue: String {
        url
    }
    var storedImageValue: Data {
        Data()
    }
    //    var ingredientsValue: [String] {
    //        ingredients ?? [Any]
    //    }
}

