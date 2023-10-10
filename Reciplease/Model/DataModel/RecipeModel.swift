//
//  RecipeModel.swift
//  Reciplease
//
//  Created by Hugues Fils on 04/10/2023.
//

import Foundation
import SwiftUI

struct ApiResponse: Decodable {
    let hits: [Hit]
    let links: Links
    
    private enum CodingKeys: String, CodingKey {
        case links = "_links"
        case hits
    }
}

struct Hit: Decodable {
    let recipe: Recipe
}

struct Recipe: Decodable {
    let label: String
    let image: String
    let ingredientLines: [String]
    let ingredients: [Ingredient]
    let totalTime: Int
    let url: String
}

struct Ingredient: Decodable {
    let food: String
}

struct Links: Decodable {
    let next: Next?
}

struct Next: Decodable {
    let href: String?
}

extension Recipe {
    var foodIngredients: [String] {
        return ingredients.map { $0.food }
    }
}

protocol RecipeProtocol: Identifiable {
    associatedtype Id
    var id: Id { get }
    var labelValue: String { get }
    var urlValue: String { get }
    var imageValue: String { get }
    var totalTimeValue: Int { get }
    var ingredientLinesValue: [String] { get }
    var foodIngredientsValue: [String] { get }
    var storedImageValue: Data { get }
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
    var foodIngredientsValue: [String] {
        foodIngredients ?? []
    }
    
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
    var foodIngredientsValue: [String] {
        foodIngredients
    }
}

extension Int {
    func toTimeString() -> String {
        let timeMeasure = Measurement(value: Double(self), unit: UnitDuration.minutes)
        let hours = timeMeasure.converted(to: .hours)
        if hours.value > 1 {
            let minutes = timeMeasure.value.truncatingRemainder(dividingBy: 60)
            return String(format: "%.f %@ %.f %@", hours.value, "h", minutes, "min")
        }
        return String(format: "%.f %@", timeMeasure.value, "min")
    }
}
