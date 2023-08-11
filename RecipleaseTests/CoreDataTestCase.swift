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
    
    private let dataController = DataController()
    
    override func setUp() {
        super.setUp()
        
        appTestContext = createInMemoryManagedObjectContext()
        
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
        //given
        let recipe = Recipe(label: "FirstRecipe",
                            image: "imageTest",
                            ingredientLines: ["lemon, cheese"],
                            ingredients: [ingredient(food: "lemon"), ingredient(food: "cheese")],
                            url: "www.testtest.com",
                            totalTime: 10)
        //when
        let expectation = XCTestExpectation(description: "waiting for data saving")
        dataController.addFavorite(label: recipe.label, image: recipe.image, ingredientLines: recipe.ingredientLines, url: recipe.url, totalTime: recipe.totalTime, foodIngredients: recipe.foodIngredients, completionHandler: {
            let favRecipeRequest: NSFetchRequest<FavRecipe> = FavRecipe.fetchRequest()
            do {
                let favRecipe = try self.appTestContext!.fetch(favRecipeRequest)
                XCTAssertEqual(favRecipe.last!.label, recipe.label)
            } catch {
                print("Error loading favRecipe: \(error)")
                XCTAssert(false)
            }
            
            expectation.fulfill()
           
        })
        //then
        wait(for: [expectation], timeout: 2)
        
    }
    
    func testRemoveFromFavorite() {
        
    }
    
    func testDownloadImage() {
        
    }
    
}
