//
//  RecipeModel.swift
//  Reciplease
//
//  Created by Hugues Fils on 09/05/2023.
//

import Foundation
import SwiftUI

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
    var ingredients: [ingredient]
    var url: String
    var totalTime: Int
}

struct ingredient: Codable {
    var food: String
}

extension Recipe {
    var foodIngredients: [String] {
        return ingredients.map { $0.food }
    }
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
