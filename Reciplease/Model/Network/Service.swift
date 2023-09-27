//
//  Service.swift
//  Reciplease
//
//  Created by Hugues Fils on 26/09/2023.
//

import Foundation
import Combine
import Alamofire

struct NetworkError: Error {
  let initialError: AFError
  let backendError: BackendError?
}

struct BackendError: Codable, Error {
    var status: String
    var message: String
}

protocol ServiceProtocol {
    func loadData(ingredients: [String]) -> AnyPublisher<DataResponse<RecipesResponse, NetworkError>, Never>
}


class Service {
    static let shared: ServiceProtocol = Service()
    private init() { }
}

extension Service: ServiceProtocol {
    func loadData(ingredients: [String]) -> AnyPublisher<DataResponse<RecipesResponse, NetworkError>, Never> {
        let url = URL(string: "https://api.edamam.com/search?q=\(ingredients.joined(separator: ","))&app_id=\(ApiData.api_id)&app_key=\(ApiData.api_key)")!
        
        return AF.request(url,
                          method: .get)
            .validate()
            .publishDecodable(type: RecipesResponse.self)
            .map { response in
                response.mapError { error in
                    let backendError = response.data.flatMap { try? JSONDecoder().decode(BackendError.self, from: $0)}
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
