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
    
    private var sut: Service!
    private var manager: Session! = {
        let configuration: URLSessionConfiguration = {
            let configuration = URLSessionConfiguration.default
            configuration.protocolClasses = [MockURLProtocol.self]
            return configuration
        }()
        return Session(configuration: configuration)
    }()
    
    override func setUp() {
        super.setUp()
        sut = Service(manager: manager)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testLoadData_WithValidURL_ReturnsRecipes() {
            let ingredients = ["ingredient"]
            let expectation = XCTestExpectation(description: "Callback is called with recipes")
            
            MockURLProtocol.requestHandler = { request in
                let encoder = JSONEncoder()
                let recipe = Recipe(label: "test", image: "imagepath.jpg", ingredientLines: ["ingredient"], ingredients: [Ingredient(food: "tomato")], totalTime: 10, url: "https://www.test.com")
                let response = ApiResponse(hits: [Hit(recipe: recipe)], links: Links(next: Next(href: "test")))
                let data = try encoder.encode(response)
                return (HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!, data)
            }
            
            
            sut.loadData(ingredients: ingredients) { (recipes, next, cases) in
                XCTAssertEqual(recipes?.first?.label, "test")
                XCTAssertEqual(recipes?.first?.image, "imagepath.jpg")
                XCTAssertEqual(recipes?.first?.ingredientLines, ["ingredient"])
                XCTAssertEqual(recipes?.first?.ingredients.count, 1)
                XCTAssertEqual(recipes?.first?.ingredients.first?.food, "tomato")
                XCTAssertEqual(recipes?.first?.totalTime, 10)
                XCTAssertEqual(recipes?.first?.url, "https://www.test.com")
                
                XCTAssertEqual(next?.href, "test")
                
                XCTAssertEqual(cases, .Success)
                
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 5.0)
        }
        
        func testLoadData_WithWrongDataProvided_ReturnsWrongDataReceived() {
            let ingredients = ["lemon"]
            let expectation = XCTestExpectation(description: "Callback is called with BadUrlForRequest")
            
            MockURLProtocol.requestHandler = {request in
                let encoder = JSONEncoder()
                let data = try encoder.encode(["test": "test"])
                return (HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!, data)
            }
  
            sut.loadData(ingredients: ingredients) { (recipes, next, cases) in
                XCTAssertNil(recipes)
                XCTAssertNil(next)
                XCTAssertEqual(cases, .WrongDataReceived)
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 5.0)
        }
        
        func testLoadData_WithEmptyData_ReturnsEmpty() {
            let ingredients = ["ingredient"]
            let expectation = XCTestExpectation(description: "Callback is called with Empty")
            
            MockURLProtocol.requestHandler = { request in
                let encoder = JSONEncoder()
                let response = ApiResponse(hits: [], links: Links(next: Next(href: "")))
                let data = try encoder.encode(response)
                return (HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!, data)
            }
            
            sut.loadData(ingredients: ingredients) { (recipes, next, cases) in
                XCTAssertNil(recipes)
                XCTAssertNil(next)
                XCTAssertEqual(cases, .Empty)
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 5.0)
        }
        
        func testLoadData_WithInvalidStatusCode_ReturnsHttpStatusCodeError() {
            let ingredients = ["ingredient"]
            let expectation = XCTestExpectation(description: "Callback is called with HttpStatusCodeError")
            
            MockURLProtocol.requestHandler = { request in
                let encoder = JSONEncoder()
                let recipe = Recipe(label: "test", image: "imagepath.jpg", ingredientLines: ["ingredient"], ingredients: [Ingredient(food: "tomato")], totalTime: 10, url: "https://www.test.com")
                let response = ApiResponse(hits: [Hit(recipe: recipe)], links: Links(next: Next(href: "test")))
                let data = try encoder.encode(response)
                return (HTTPURLResponse(url: request.url!, statusCode: 400, httpVersion: nil, headerFields: nil)!, data)
            }
            
            sut.loadData(ingredients: ingredients) { (recipes, next, cases) in
                XCTAssertNil(recipes)
                XCTAssertNil(next)
                XCTAssertEqual(cases, .HttpStatusCodeError)
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 5.0)
        }
}
