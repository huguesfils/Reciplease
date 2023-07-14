//
//  RecipeService.swift
//  Reciplease
//
//  Created by Hugues Fils on 04/07/2023.
//

import Foundation

class RecipeService {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func loadData(ingredients: [String]) async throws  -> [Recipe] {
        guard let url = URL(string: "https://api.edamam.com/search?q=\(ingredients.joined(separator: ","))&app_id=\(ApiData.api_id)&app_key=\(ApiData.api_key)")
        else {
            print("Invalid URL")
            return []
        }
        do {
            let (data, _) = try await session.data(from: url)
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

class URLSessionMock: URLSession {
    
//    override func data(from url: URL) async throws -> (Data, URLResponse) {
//        let data =  self.data
//        
//    }
//    
    
}
