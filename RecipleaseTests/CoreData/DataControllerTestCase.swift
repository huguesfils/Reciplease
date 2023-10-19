//
//  DataControllerTestCase.swift
//  RecipleaseTests
//
//  Created by Hugues Fils on 02/08/2023.
//

import XCTest
import CoreData
@testable import Reciplease

final class DataControllerTestCase: XCTestCase {
    
    var dataController: DataController!
    
    var coreDataTestStack: CoreDataTestStack!
    
    private let correctImageUrl = "https://urlz.fr/ncHy"
    private let wrongImageUrl = "123://example.com"
    
    let recipe = Recipe(label: "FirstRecipe",
                        image: "https://urlz.fr/ncHy",
                        ingredientLines: ["lemon, cheese"],
                        ingredients: [Ingredient(food: "lemon"), Ingredient(food: "cheese")],
                        totalTime: 10,
                        url: "www.testtest.com"
    )
    
    override func setUp() {
        super.setUp()
        coreDataTestStack = CoreDataTestStack()
        dataController = DataController(mainContext: coreDataTestStack.mainContext)
    }
    
    override func tearDown() {
        dataController = nil
        super.tearDown()
    }
    
    func createInMemoryManagedObjectContext() -> NSManagedObjectContext? {
        guard let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main]) else { return nil }
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            print("Error creating test core data store: \(error)")
            return nil
        }
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        return managedObjectContext
    }
    
    
    func testAddToFavorite() {
        let recipe = Recipe(label: "test", image: "imagepath.jpg", ingredientLines: ["ingredient"], ingredients: [Ingredient(food: "tomato")], totalTime: 10, url: "testURL")
        
        let expectation = XCTestExpectation(description: "Add to favorite completion handler called")
        
        do {
            try dataController.addToFavorite(recipe: recipe) {
                expectation.fulfill()
            }
        } catch {
            XCTFail("Error thrown while adding recipe to favorites: \(error.localizedDescription)")
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    
    func testFetchFavorites() {
        let expectation = XCTestExpectation(description: "Fetch favorites completion called")
        
        dataController.fetchFavorites { (recipes) in
            XCTAssertNotNil(recipes)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testRemoveFromFavorite() {
        let favRecipe = FavRecipe()
        
        do {
            try dataController.removeFromFavorite(recipe: favRecipe)
        } catch {
            XCTFail("Error thrown while deleting recipe from favorites: \(error.localizedDescription)")
        }
        
        XCTAssertFalse(dataController.mainContext.hasChanges)
    }
    
    func testFetchFavorite() {
        let favRecipe = FavRecipe(context: dataController.mainContext)
        favRecipe.url = "www.testurl.com"
        
        do {
            try dataController.mainContext.save()
        } catch {
            XCTFail("Error saving context: \(error.localizedDescription)")
        }
        
        let expectation = XCTestExpectation(description: "Fetch favorite completion called")
        
        dataController.fetchFavorite(url: "www.testurl.com") { (recipe) in
            XCTAssertNotNil(recipe)
            XCTAssertEqual(recipe?.url, "www.testurl.com")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchFavoriteNil() {
        let expectation = XCTestExpectation(description: "Fetch favorite completion called with nil")
        
        dataController.fetchFavorite(url: "www.nonexistenturl.com") { (recipe) in
            XCTAssertNil(recipe)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testIsFavoriteTrue() {
        let favRecipe = FavRecipe(context: dataController.mainContext)
        favRecipe.url = "www.testurl.com"
        
        do {
            try dataController.mainContext.save()
        } catch {
            XCTFail("Error saving context: \(error.localizedDescription)")
        }
        
        let expectation = XCTestExpectation(description: "isFavorite completion called with true")
        
        let recipe: any RecipeProtocol = favRecipe
        
        dataController.isFavorite(recipe: recipe) { isFavorite in
            XCTAssertTrue(isFavorite ?? false)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testIsFavoriteFalse() {
        let expectation = XCTestExpectation(description: "isFavorite completion called with false")
        
        let recipe = Recipe(label: "NonFavoriteRecipe", image: "imagepath.jpg", ingredientLines: ["ingredient"], ingredients: [Ingredient(food: "tomato")], totalTime: 10, url: "www.nonfavoriterecipe.com")
        
        dataController.isFavorite(recipe: recipe) { isFavorite in
            XCTAssertFalse(isFavorite ?? true)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }

    func test_DataController_downloadImage_wrongUrl() {
        URLProtocol.registerClass(MockURLProtocol.self)
        MockURLProtocol.requestHandler = {request in
            let encoder = JSONEncoder()
            let data = try encoder.encode(["test": "test"])
            return (HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!, data)
        }
        
        let image = wrongImageUrl
        
        let expectation = XCTestExpectation(description: "waiting for data")
        
        dataController?.downloadImage(imageUrl: image, completionHandler: { data in
            XCTAssertNil(data)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 20)
    }
    
    func test_DataController_downloadImage_error() {
        URLProtocol.registerClass(MockURLProtocol.self)
        MockURLProtocol.requestHandler = {request in
            let encoder = JSONEncoder()
            let data = try encoder.encode(["test": "test"])
            
            return (HTTPURLResponse(url: request.url!, statusCode: 400, httpVersion: nil, headerFields: nil)!, data)
        }
        let image = correctImageUrl
        
        let expectation = XCTestExpectation(description: "waiting for data")
        dataController?.downloadImage(imageUrl: image, completionHandler: { data in
            XCTAssertNil(data)
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 20)
    }
}
