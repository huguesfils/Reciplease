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
    
    
    
   
    //class URLSessionMock: URLSession {
    //    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    //
    //        // Properties that enable us to set exactly what data or error
    //        // we want our mocked URLSession to return for any request.
    //        var data: Data?
    //        var error: Error?
    //
    //        override func dataTask(
    //            with url: URL,
    //            completionHandler: @escaping CompletionHandler
    //        ) -> URLSessionDataTask {
    //            let data = self.data
    //            let error = self.error
    //
    //            return URLSessionDataTaskMock(closure: {
    //                completionHandler(data, nil, error)
    //            })
    //        }
    //
    //}
    //
    //class URLSessionDataTaskMock : URLSessionDataTask {
    //    private let closure: () -> Void
    //
    //   init(closure: @escaping () -> Void) {
    //       self.closure = closure
    //   }
    //
    //   override func resume() {
    //       closure()
    //   }
    //}
