//
//  RecipeService.swift
//  Reciplease
//
//  Created by Hugues Fils on 04/07/2023.
//

import Foundation
import Alamofire

class RecipeService {
    
//
    enum Error: Swift.Error {
        case HttpStatusCodeError
        case WrongDataReceived
        case BadUrlForRequest
        case Empty
        case Success
    }

    private let session: URLSession
    
    var recipes: [Recipe] = []

    init(session: URLSession = .shared) {
        self.session = session
    }
    
        func loadData(ingredients: [String]) async throws  -> [Recipe] {
            guard let url = URL(string: "https://api.edamam.com/search?q=\(ingredients.joined(separator: ","))&app_id=\(ApiData.api_id)&app_key=\(ApiData.api_key)")
            else {
                print("Invalid URL")
                throw Error.BadUrlForRequest
            }
    
            let (data, response) = try await session.data(from: url)
    
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Bad status code")
                throw Error.HttpStatusCodeError
            }
            if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                return decodedResponse.hits.map { hit in
                    hit.recipe
                }
            } else {
                print("Invalid data")
                throw Error.WrongDataReceived
            }
        }
    
//    func loadData(ingredients: [String], callback: @escaping ([Recipe]?, Error) -> Void) {
//        guard let url = URL(string: "https://api.edamam.com/search?q=\(ingredients.joined(separator: ","))&app_id=\(ApiData.api_id)&app_key=\(ApiData.api_key)")
//        else {
//            print("Invalid URL")
//            callback(nil, .BadUrlForRequest)
//            return
//        }
//        session.request(url).responseDecodable(of: Response.self) { [weak self] response in
//            guard response.error == nil else {
//                callback(nil, .WrongDataReceived)
//                return
//            }
//
//            guard let data = response.value, !data.hits.isEmpty else {
//                callback(nil, .Empty)
//                return
//            }
//
//            guard let urlResponse = response.response, urlResponse.statusCode == 200 else {
//                callback(nil, .HttpStatusCodeError)
//                return
//            }
//
//            data.hits.forEach { hit in
//                let recipe = Recipe(label: hit.recipe.label,
//                                    image: hit.recipe.image,
//                                    ingredientLines: hit.recipe.ingredientLines,
//                                    ingredients: hit.recipe.ingredients,
//                                    url: hit.recipe.url,
//                                    totalTime: hit.recipe.totalTime)
//
//                self?.recipes.append(recipe)
//
//            }
//            callback(self?.recipes, .Success)
//        }
//    }
  
}



