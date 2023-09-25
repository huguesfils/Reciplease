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
//    var appTestContext: NSManagedObjectContext!

    var coreDataTestStack: CoreDataTestStack!
    
    private let correctImageUrl = "https://urlz.fr/ncHy"
    private let wrongImageUrl = "123://example.com"
    
    override func setUp() {
        super.setUp()
//        appTestContext = createInMemoryManagedObjectContext()
        coreDataTestStack = CoreDataTestStack()
        dataController = DataController(mainContext: coreDataTestStack.mainContext)
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
    
    
    func test_DataController_addToFavorite() {
        let recipe = Recipe(label: "FirstRecipe",
                            image: correctImageUrl,
                            ingredientLines: ["lemon, cheese"],
                            ingredients: [ingredient(food: "lemon"), ingredient(food: "cheese")],
                            url: "www.testtest.com",
                            totalTime: 10)
        
        let expectation = XCTestExpectation(description: "waiting for data saving")
        
        dataController?.addFavorite(recipe: recipe, completionHandler: {
            
            let favRecipe = self.dataController.fetchFavorites()
            print(favRecipe as Any)
            
            XCTAssertEqual(favRecipe?.last?.label, recipe.label)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 2)
    }
    
    
    func test_DataController_removeFavorite() {
        self.deleteAllData("FavRecipe")
        
        let recipe = Recipe(label: "FirstRecipe",
                            image: correctImageUrl,
                            ingredientLines: ["lemon, cheese"],
                            ingredients: [ingredient(food: "lemon"), ingredient(food: "cheese")],
                            url: "www.testtest.com",
                            totalTime: 10)
        
        let expectation = XCTestExpectation(description: "waiting for data saving")
        dataController?.addFavorite(recipe: recipe, completionHandler: {
            let favRecipe = self.dataController.fetchFavorites()
            
            self.dataController?.removeFavorite(recipe: (favRecipe?.first!)!)
            
            let favRecipes = self.dataController.fetchFavorites()
            
            XCTAssert(favRecipes!.isEmpty)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 2)
    }
    
    func test_DataController_downloadImage_wrongUrl() {
        URLProtocol.registerClass(MockURLProtocol.self)
        MockURLProtocol.requestHandler = {request in
            let encoder = JSONEncoder()
            let data = try encoder.encode(["test": "test"])
            return (HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!, data)
        }
        
        let image = wrongImageUrl // = "✅!èçà!ç!è"
        
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

extension DataControllerTestCase {
    private func deleteAllData(_ entity: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try dataController.mainContext.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                dataController.mainContext.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }
}
