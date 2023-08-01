//
//  RecipeService.swift
//  Reciplease
//
//  Created by Hugues Fils on 04/07/2023.
//

import Foundation

class RecipeService {
    
    enum Error: Swift.Error {
        case HttpStatusCodeError
        case WrongDataReceived
        case BadUrlForRequesst
    }
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func loadData(ingredients: [String]) async throws  -> [Recipe] {
        guard let url = URL(string: "https://api.edamam.com/search?q=\(ingredients.joined(separator: ","))&app_id=\(ApiData.api_id)&app_key=\(ApiData.api_key)")
        else {
            print("Invalid URL")
            throw Error.BadUrlForRequesst
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
}



