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
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void

        // Properties that enable us to set exactly what data or error
        // we want our mocked URLSession to return for any request.
        var data: Data?
        var error: Error?

        override func dataTask(
            with url: URL,
            completionHandler: @escaping CompletionHandler
        ) -> URLSessionDataTask {
            let data = self.data
            let error = self.error

            return URLSessionDataTaskMock(closure: {
                completionHandler(data, nil, error)
            })
        }
    
}

class URLSessionDataTaskMock : URLSessionDataTask {
    private let closure: () -> Void

   init(closure: @escaping () -> Void) {
       self.closure = closure
   }

   // We override the 'resume' method and simply call our closure
   // instead of actually resuming any task.
   override func resume() {
       closure()
   }
    
    
    
}
