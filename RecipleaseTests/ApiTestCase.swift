//
//  ApiTestCase.swift
//  RecipleaseTests
//
//  Created by Hugues Fils on 01/07/2023.
//

import XCTest
@testable import Reciplease

final class ApiTestCase: XCTestCase {
    
    func testVincent() async throws {
        URLProtocol.registerClass(MockURLProtocol.self)
        MockURLProtocol.requestHandler = {request in
            let encoder = JSONEncoder()
            let data = try encoder.encode(["toto": "titi"])
            return (HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!, data)
        }
        
        let service = RecipeService()

        do {
            _ = try await service.loadData(ingredients: ["turc"])
            XCTAssert(false)
        } catch  {
            XCTAssert(true)
            XCTAssert(error is RecipeService.Error)
        }
    }
}
