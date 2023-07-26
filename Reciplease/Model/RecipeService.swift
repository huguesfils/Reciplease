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
    
    /*
        func loadData(ingredients: [String], completion: @escaping (Result<[Recipe], Error>) -> Void) {
            guard let url = URL(string: "https://api.edamam.com/search?q=\(ingredients.joined(separator: ","))&app_id=\(ApiData.api_id)&app_key=\(ApiData.api_key)") else {
                let info = [NSLocalizedDescriptionKey: "Invalid URL"]
                let error = NSError(domain: "com.example.app",
                                    code: -1,
                                    userInfo: info)
                completion(.failure(error))
                return
            }
    
            let task = session.dataTask(with: url) { (data, response, error) in
    
                if let error = error {
                    completion(.failure(error))
                    return
    
                }
    
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    completion(.failure())
                          return
                        }
    
                        // Parse data
                        if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                            return (decodedResponse.hits ?? [].map { hit in
                                hit.recipe
                                completion(Result.success(decodedResponse))
                            }
                        } else {
                                completion(Result.failure(error))
    
                      }
                    }
    
            task.resume()
        }
    }*/
    
    
    func loadData(ingredients: [String]) async throws  -> [Recipe] {
        guard let url = URL(string: "https://api.edamam.com/search?q=\(ingredients.joined(separator: ","))&app_id=\(ApiData.api_id)&app_key=\(ApiData.api_key)")
        else {
            print("Invalid URL")
            throw Error.BadUrlForRequesst
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            print("badd code error")
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
    
    
    
    //        func loadData(ingredients: [String]) async throws  -> [Recipe] {
    //            guard let url = URL(string: "https://api.edamam.com/search?q=\(ingredients.joined(separator: ","))&app_id=\(ApiData.api_id)&app_key=\(ApiData.api_key)")
    //            else {
    //                print("Invalid URL")
    //                return []
    //            }
    //            do {
    //                let (data, _) = try await session.data(from: url)
    //                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
    //                    return (decodedResponse.hits ?? []).map { hit in
    //                        hit.recipe
    //                    }
    //                } else {
    //                    return []
    //                }
    //            } catch {
    //                print("Invalid data")
    //                return []
    //            }
    //        }
    //    }
    
    
        class MockURLProtocol: URLProtocol {
            static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?
    
            override class func canInit(with request: URLRequest) -> Bool {
                // To check if this protocol can handle the given request.
                return true
            }
    
    
            override class func canonicalRequest(for request: URLRequest) -> URLRequest {
                // Here you return the canonical version of the request but most of the time you pass the orignal one.
                return request
            }
    
            override func startLoading() {
                guard let handler = MockURLProtocol.requestHandler else {
                    fatalError("Handler is unavailable.")
                }
    
                do {
                    // 2. Call handler with received request and capture the tuple of response and data.
                    let (response, data) = try handler(request)
    
                    // 3. Send received response to the client.
                    client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
    
                    if let data = data {
                        // 4. Send received data to the client.
                        client?.urlProtocol(self, didLoad: data)
                    }
    
                    // 5. Notify request has been finished.
                    client?.urlProtocolDidFinishLoading(self)
                } catch {
                    // 6. Notify received error.
                    client?.urlProtocol(self, didFailWithError: error)
                }
                // This is where you create the mock response as per your test case and send it to the URLProtocolClient.
            }
    
            override func stopLoading() {
                // This is called if the request gets canceled or completed.
            }
        }

