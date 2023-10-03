//
//  ApiService.swift
//  Reciplease
//
//  Created by Hugues Fils on 04/07/2023.
//

import Foundation
import Alamofire


class ApiService {
    
    var recipes = [Recipe]()
    
    enum Cases {
        case HttpStatusCodeError
        case WrongDataReceived
        case BadUrlForRequest
        case Empty
        case Success
    }
    
    func loadData2(ingerdients: [String], callback: @escaping ([Recipe]?, Next?, Cases) -> Void) {
        guard let url = URL(string: "https://api.edamam.com/api/recipes/v2")
        else {
            print("Invalid URL")
            callback(nil, nil, .BadUrlForRequest)
            return
        }
        
        let parameters: Parameters = [
            "app_key": ApiData.api_key,
            "app_id": ApiData.api_id,
            "type": "public",
            "random": true,
            "q": ingredients.joined(separator: "+"),
            "field": ["label", "image", "ingredientLines", "ingredients", "totalTime", "url"]
            
        ]
        AF.request(url, method: .get, parameters: parameters).responseDecodable(of: RecipeResponse.self) { [weak self] response in
            guard response.error == nil else {
                callback(nil, nil, .WrongDataReceived)
                return
            }
            
            guard let data = response.value, !data.hits.isEmpty else {
                callback(nil, nil, .Empty)
                return
            }
            
            guard let urlResponse = response.response, urlResponse.statusCode == 200 else {
                callback(nil, nil, .HttpStatusCodeError)
                return
            }
            
            data.hits.forEach { hit in
                let recipe = Recipe(label: hit.recipe.label,
                                    image: hit.recipe.image,
                                    ingredientLines: hit.recipe.ingredientLines,
                                    ingredients: hit.recipe.ingredients,
                                    totalTime: hit.recipe.totalTime,
                                    url: hit.recipe.url)
                
                self?.recipes.append(recipe)
            }
            callback(self?.recipes, data.links.next, .Success)
        }
    }
    
    func loadData(viewModel: SearchViewModel, callback: @escaping ([Recipe]?, Next?, Cases) -> Void) {
        guard let url = URL(string: "https://api.edamam.com/api/recipes/v2")
        else {
            print("Invalid URL")
            callback(nil, nil, .BadUrlForRequest)
            return
        }
        
        let parameters: Parameters = [
            "app_key": ApiData.api_key,
            "app_id": ApiData.api_id,
            "type": "public",
            "random": true,
            "q": viewModel.ingredients.joined(separator: "+"),
            "field": ["label", "image", "ingredientLines", "ingredients", "totalTime", "url"]
            
        ]
        AF.request(url, method: .get, parameters: parameters).responseDecodable(of: RecipeResponse.self) { [weak self] response in
            guard response.error == nil else {
                callback(nil, nil, .WrongDataReceived)
                return
            }
            
            guard let data = response.value, !data.hits.isEmpty else {
                callback(nil, nil, .Empty)
                return
            }
            
            guard let urlResponse = response.response, urlResponse.statusCode == 200 else {
                callback(nil, nil, .HttpStatusCodeError)
                return
            }
            
            data.hits.forEach { hit in
                let recipe = Recipe(label: hit.recipe.label,
                                    image: hit.recipe.image,
                                    ingredientLines: hit.recipe.ingredientLines,
                                    ingredients: hit.recipe.ingredients,
                                    totalTime: hit.recipe.totalTime,
                                    url: hit.recipe.url)
                
                self?.recipes.append(recipe)
            }
            callback(self?.recipes, data.links.next, .Success)
        }
    }
    
    func getNextPage(nextPage: Next, callback: @escaping ([Recipe]?, Next?, Cases) -> Void) {
        guard let url = nextPage.href else { return }
        
        AF.request(URL(string: url)!, method: .get).responseDecodable(of: RecipeResponse.self) { [weak self] response in
            guard response.error == nil else {
                callback(nil, nil, .WrongDataReceived)
                return
            }
            
            guard let data = response.value, !data.hits.isEmpty else {
                callback(nil, nil, .Empty)
                return
            }
            
            guard let urlResponse = response.response, urlResponse.statusCode == 200 else {
                callback(nil, nil, .HttpStatusCodeError)
                return
            }
            
            data.hits.forEach { hit in
                let recipe = Recipe(label: hit.recipe.label,
                                    image: hit.recipe.image,
                                    ingredientLines: hit.recipe.ingredientLines,
                                    ingredients: hit.recipe.ingredients,
                                    totalTime: hit.recipe.totalTime,
                                    url: hit.recipe.url)
                
                self?.recipes.append(recipe)
            }
            
            callback(self?.recipes, data.links.next, .Success)
        }
    }
    
    
}



