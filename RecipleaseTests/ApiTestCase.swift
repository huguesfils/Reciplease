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
    
    func testLoadDataWithInvalidUrl() async throws {
        URLProtocol.registerClass(MockURLProtocol.self)
        MockURLProtocol.requestHandler = {request in
            let encoder = JSONEncoder()
            let data = try encoder.encode(["test": "test"])
            return (HTTPURLResponse(url: request.url!, statusCode: 400, httpVersion: nil, headerFields: nil)!, data)
        }
        
        let service = RecipeService()
        
        do {
            _ = try await service.loadData(ingredients: ["2️⃣2️⃣"])
            XCTAssert(false)
        } catch  {
            XCTAssert(true)
            XCTAssert(error is RecipeService.Error)
        }
    }
    
    func testLoadWithWithCorrectResponse() async throws {
        URLProtocol.registerClass(MockURLProtocol.self)
        MockURLProtocol.requestHandler = {request in
            let encoder = JSONEncoder()
            let recipe = Recipe(label: "test", image: "imagepath.jpg", ingredientLines: ["ingredient1", "ingredient2"], ingredients: [ingredient(food: "tomato")], url: "http://www.google.com", totalTime: 10)
            let response = Response(hits: [Hit(recipe: recipe)])
            let data = try encoder.encode(response)
            return (HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!, data)
        }
        
        let service = RecipeService()
        
        do {
            let result = try await service.loadData(ingredients: ["tomato"])
            XCTAssertEqual(result.first?.label, "test")
            XCTAssertEqual(result.first?.image, "imagepath.jpg")
            XCTAssertEqual(result.first?.ingredientLines, ["ingredient1", "ingredient2"])
            XCTAssertEqual(result.first?.ingredients.first?.food, "tomato")
            XCTAssertEqual(result.first?.url, "http://www.google.com")
            XCTAssertEqual(result.first?.totalTime, 10)
        } catch  {
            XCTAssert(false)
        }
    }
}
