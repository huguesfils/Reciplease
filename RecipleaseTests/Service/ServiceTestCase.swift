//
//  ServiceTestCase.swift
//  RecipleaseTests
//
//  Created by Hugues Fils on 17/10/2023.
//

import XCTest
import Alamofire
@testable import Reciplease

final class ServiceTestCase: XCTestCase {
    
    var sut: Service!
    
    override func setUp() {
        super.setUp()
        sut = Service()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testLoadData_WithValidURL_ReturnsRecipes() {
            // Arrange
            let ingredients = ["ingredient1", "ingredient2"]
            let expectation = XCTestExpectation(description: "Callback is called with recipes")
            
            let mockResponseData = """
            {
                "from": 1,
                "to": 2,
                "count": 2,
                "_links": {},
                "hits": [
                    {
                        "recipe": {
                            "label": "Recipe 1",
                            "image": "www.hezyafu.com",
                            "ingredientLines": ["Ingredient 1", "Ingredient 2"],
                            "ingredients": [
                                { "food": "Food 1" },
                                { "food": "Food 2" }
                            ],
                            "totalTime": 30,
                            "url": "https://www.example.com/recipe1"
                        }
                    },
                    {
                        "recipe": {
                            "label": "Recipe 2",
                            "image": "www.hezyafu.com",
                            "ingredientLines": ["Ingredient 3", "Ingredient 4"],
                            "ingredients": [
                                { "food": "Food 3" },
                                { "food": "Food 4" }
                            ],
                            "totalTime": 45,
                            "url": "https://www.example.com/recipe2"
                        }
                    }
                ],
                "links": {
                    "next": {
                        "href": "https://www.example.com/next"
                    }
                }
            }
            """.data(using: .utf8)!
            
            MockURLProtocol.requestHandler = { request in
                let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
                return (response, mockResponseData)
            }
            
            // Act
            sut.loadData(ingredients: ingredients) { (recipes, next, cases) in
                // Assert
                XCTAssertEqual(recipes?.count, 2)
                XCTAssertEqual(recipes?.first?.label, "Recipe 1")
                XCTAssertEqual(recipes?.first?.image, "image1.jpg")
                XCTAssertEqual(recipes?.first?.ingredientLines, ["Ingredient 1", "Ingredient 2"])
                XCTAssertEqual(recipes?.first?.ingredients.count, 2)
                XCTAssertEqual(recipes?.first?.ingredients.first?.food, "Food 1")
                XCTAssertEqual(recipes?.first?.totalTime, 30)
                XCTAssertEqual(recipes?.first?.url, "https://www.example.com/recipe1")
                
                XCTAssertEqual(next?.href, "https://www.example.com/next")
                
                XCTAssertEqual(cases, .Success)
                
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 5.0)
        }
        
//        func testLoadData_WithInvalidURL_ReturnsBadUrlForRequest() {
//            // Arrange
//            let ingredients = ["ingredient1", "ingredient2"]
//            let expectation = XCTestExpectation(description: "Callback is called with BadUrlForRequest")
//            
//            // Act
//            sut.loadData(ingredients: ingredients) { (recipes, next, cases) in
//                // Assert
//                XCTAssertNil(recipes)
//                XCTAssertNil(next)
//                XCTAssertEqual(cases, .BadUrlForRequest)
//                expectation.fulfill()
//            }
//            
//            wait(for: [expectation], timeout: 5.0)
//        }
//        
//        func testLoadData_WithWrongData_ReturnsWrongDataReceived() {
//            // Arrange
//            let ingredients = ["ingredient1", "ingredient2"]
//            let expectation = XCTestExpectation(description: "Callback is called with WrongDataReceived")
//            
//            let mockResponseData = """
//            {
//                "hits": [],
//                "links": {
//                    "next": {
//                        "href": "https://www.example.com/next"
//                    }
//                }
//            }
//            """.data(using: .utf8)!
//            
//            MockURLProtocol.requestHandler = { request in
//                let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
//                return (response, mockResponseData)
//            }
//            
//            // Act
//            sut.loadData(ingredients: ingredients) { (recipes, next, cases) in
//                // Assert
//                XCTAssertNil(recipes)
//                XCTAssertNil(next)
//                XCTAssertEqual(cases, .WrongDataReceived)
//                expectation.fulfill()
//            }
//            
//            wait(for: [expectation], timeout: 5.0)
//        }
//        
//        func testLoadData_WithEmptyData_ReturnsEmpty() {
//            // Arrange
//            let ingredients = ["ingredient1", "ingredient2"]
//            let expectation = XCTestExpectation(description: "Callback is called with Empty")
//            
//            let mockResponseData = """
//            {
//                "hits": [],
//                "links": {
//                    "next": {
//                        "href": "test"
//                    }
//                }
//            }
//            """.data(using: .utf8)!
//            
//            MockURLProtocol.requestHandler = { request in
//                let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
//                return (response, mockResponseData)
//            }
//            
//            // Act
//            sut.loadData(ingredients: ingredients) { (recipes, next, cases) in
//                // Assert
//                XCTAssertNil(recipes)
//                XCTAssertNil(next)
//                XCTAssertEqual(cases, .Empty)
//                expectation.fulfill()
//            }
//            
//            wait(for: [expectation], timeout: 5.0)
//        }
//        
//        func testLoadData_WithInvalidStatusCode_ReturnsHttpStatusCodeError() {
//            // Arrange
//            let ingredients = ["ingredient1", "ingredient2"]
//            let expectation = XCTestExpectation(description: "Callback is called with HttpStatusCodeError")
//            
//            let mockResponseData = """
//            {
//                "hits": [
//                    {
//                        "recipe": {
//                            "label": "Recipe 1",
//                            "image": "image1.jpg",
//                            "ingredientLines": ["Ingredient 1", "Ingredient 2"],
//                            "ingredients": [
//                                { "food": "Food 1" },
//                                { "food": "Food 2" }
//                            ],
//                            "totalTime": 30,
//                            "url": "https://www.example.com/recipe1"
//                        }
//                    }
//                ],
//                "links": {
//                    "next": {
//                        "href": "https://www.example.com/next"
//                    }
//                }
//            }
//            """.data(using: .utf8)!
//            
//            MockURLProtocol.requestHandler = { request in
//                let response = HTTPURLResponse(url: request.url!, statusCode: 400, httpVersion: nil, headerFields: nil)!
//                return (response, mockResponseData)
//            }
//            
//            // Act
//            sut.loadData(ingredients: ingredients) { (recipes, next, cases) in
//                // Assert
//                XCTAssertNil(recipes)
//                XCTAssertNil(next)
//                XCTAssertEqual(cases, .HttpStatusCodeError)
//                expectation.fulfill()
//            }
//            
//            wait(for: [expectation], timeout: 5.0)
//        }
}
