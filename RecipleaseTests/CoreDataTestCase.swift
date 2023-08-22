//
//  CoreDataTestCase.swift
//  RecipleaseTests
//
//  Created by Hugues Fils on 02/08/2023.
//

import XCTest
import CoreData
@testable import Reciplease

final class CoreDataTestCase: XCTestCase {
    
    private var appTestContext: NSManagedObjectContext?
    private var dataController: DataController?
    
    private let correctImageUrl = "https://urlz.fr/ncHy"
    private let wrongImageUrl = "88889ED8FIDSIFHDSF8àç!èçà!ç!è"
    
    override func setUp() {
        super.setUp()
        appTestContext = createInMemoryManagedObjectContext()
        dataController = DataController(mainContext: appTestContext!)
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
    
    func testAddToFavoriteSucess() {
        
        let recipe = Recipe(label: "FirstRecipe",
                            image: correctImageUrl,
                            ingredientLines: ["lemon, cheese"],
                            ingredients: [ingredient(food: "lemon"), ingredient(food: "cheese")],
                            url: "www.testtest.com",
                            totalTime: 10)
        
        let expectation = XCTestExpectation(description: "waiting for data saving")
        dataController?.addFavorite(label: recipe.label, image: recipe.image, ingredientLines: recipe.ingredientLines, url: recipe.url, totalTime: recipe.totalTime, foodIngredients: recipe.foodIngredients, completionHandler: {_ in
            let favRecipe = self.fetch()
            print(favRecipe as Any)
            XCTAssertEqual(favRecipe?.last?.label, recipe.label)
            
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 2)
    }
    
    
    func testRemoveFromFavoriteSucess() {
        let recipe = Recipe(label: "FirstRecipe",
                            image: correctImageUrl,
                            ingredientLines: ["lemon, cheese"],
                            ingredients: [ingredient(food: "lemon"), ingredient(food: "cheese")],
                            url: "www.testtest.com",
                            totalTime: 10)
        let expectation = XCTestExpectation(description: "waiting for data saving")
        dataController?.addFavorite(label: recipe.label, image: recipe.image, ingredientLines: recipe.ingredientLines, url: recipe.url, totalTime: recipe.totalTime, foodIngredients: recipe.foodIngredients, completionHandler: {_ in
            let favRecipe = self.fetch()
            
            self.dataController?.removeFavorite(recipe: (favRecipe?.first!)!)
            
            let favRecipes = self.fetch()
            
            XCTAssert(favRecipes!.isEmpty)
            // vider la base avant
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 2)
    }
    
    func testDownloadImageWrongUrl() {
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
    
    //    func testDownloadImageError() {
    //        let image = correctImageUrl
    //
    //        dataController?.downloadImage(imageUrl: image, completionHandler: { data in
    //            return (HTTPURLResponse(url: URL(from: image as! Decoder), statusCode: 400, httpVersion: nil, headerFields: nil)!, data)
    
    //        })
    //    }
}

extension CoreDataTestCase {
    private func fetch() -> [FavRecipe]? {
        let fetchRequest = NSFetchRequest<FavRecipe>(entityName: "FavRecipe")
        do {
            let favRecipes = try appTestContext!.fetch(fetchRequest)
            return favRecipes
        } catch let error {
            print("Failed to fetch favRecipes: \(error)")
        }
        return nil
    }
}
