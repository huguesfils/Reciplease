//
//  ApiService.swift
//  Reciplease
//
//  Created by Hugues Fils on 04/07/2023.
//

import Foundation
import Alamofire

class ApiService {
    
    enum Cases {
        case HttpStatusCodeError
        case WrongDataReceived
        case BadUrlForRequest
        case Empty
        case Success
    }
    
    var recipes: [Recipe] = []
    
    func loadData(ingredients: [String], callback: @escaping ([Recipe]?, Cases) -> Void) {
        guard let url = URL(string: "https://api.edamam.com/search?q=\(ingredients.joined(separator: ","))&app_id=\(ApiData.api_id)&app_key=\(ApiData.api_key)")
        else {
            print("Invalid URL")
            callback(nil, .BadUrlForRequest)
            return
        }
        AF.request(url).responseDecodable(of: RecipesResponse.self) { [weak self] response in
            guard response.error == nil else {
                callback(nil, .WrongDataReceived)
                return
            }
            
            guard let data = response.value, !data.hits.isEmpty else {
                callback(nil, .Empty)
                return
            }
            
            guard let urlResponse = response.response, urlResponse.statusCode == 200 else {
                callback(nil, .HttpStatusCodeError)
                return
            }
            
            data.hits.forEach { hit in
                let recipe = Recipe(label: hit.recipe.label,
                                    image: hit.recipe.image,
                                    ingredientLines: hit.recipe.ingredientLines,
                                    ingredients: hit.recipe.ingredients,
                                    url: hit.recipe.url,
                                    totalTime: hit.recipe.totalTime)
                
                self?.recipes.append(recipe)
                
            }
            callback(self?.recipes, .Success)
        }
    }
    
    
}



