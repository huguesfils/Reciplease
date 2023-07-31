//
//  ApiTestCase.swift
//  RecipleaseTests
//
//  Created by Hugues Fils on 01/07/2023.
//

import XCTest
@testable import Reciplease

final class ApiTestCase: XCTestCase {
    
    func testLoadDataWithInvalidData() async throws {
        URLProtocol.registerClass(MockURLProtocol.self)
        MockURLProtocol.requestHandler = {request in
            let encoder = JSONEncoder()
            let data = try encoder.encode(["test": "test"])
            return (HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!, data)
        }
        
        let service = RecipeService()

        do {
            _ = try await service.loadData(ingredients: ["test"])
            XCTAssert(false)
        } catch  {
            XCTAssert(true)
            XCTAssert(error is RecipeService.Error)
        }
    }
    
    func testLoadDataWithBadCodeResponse() async throws {
        URLProtocol.registerClass(MockURLProtocol.self)
        MockURLProtocol.requestHandler = {request in
            let encoder = JSONEncoder()
            let data = try encoder.encode(["test": "test"])
            return (HTTPURLResponse(url: request.url!, statusCode: 400, httpVersion: nil, headerFields: nil)!, data)
        }
        
        let service = RecipeService()

        do {
            _ = try await service.loadData(ingredients: ["test"])
            XCTAssert(false)
        } catch  {
            XCTAssert(true)
            XCTAssert(error is RecipeService.Error)
        }
    }
    
//    func testLoadDataWithInvalidUrl() async throws {
//        URLProtocol.registerClass(MockURLProtocol.self)
//        MockURLProtocol.requestHandler = {request in
//            let encoder = JSONEncoder()
//            let data = try encoder.encode([url: "test"])
//            return (HTTPURLResponse(url: request.url!, statusCode: 400, httpVersion: nil, headerFields: nil)!, data)
//        }
//
//        let service = RecipeService()
//
//        do {
//            _ = try await service.loadData(ingredients: ["test"])
//            XCTAssert(false)
//        } catch  {
//            XCTAssert(true)
//            XCTAssert(error is RecipeService.Error)
//        }
//    }
    
//    func testLoadWithWithCorrectResponse() async throws {
//        URLProtocol.registerClass(MockURLProtocol.self)
//        MockURLProtocol.requestHandler = {request in
//            let encoder = JSONEncoder()
//            let data = try encoder.encode(Recipe(label: <#T##String#>, image: <#T##String#>, ingredientLines: <#T##[String]#>, ingredients: <#T##[ingredient]#>, url: <#T##String#>, totalTime: <#T##Int#>))
//            return (HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!, data)
//        }
//
//        let service = RecipeService()
//
//        do {
//        let result = try await service.loadData(ingredients: ["cheese"])
//        XCTAssert(result.contains("cheese"))
//        } catch  {
//            XCTAssert(true)
//            XCTAssert(error is RecipeService.Error)
//        }
//    }
}
