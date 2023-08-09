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
//    var coreDataTestStack: CoreDataTestStack!
//    var favTestRecipes: [FavRecipe] = []
    
    let dataController = DataController()
     
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
        dataController.addFavorite(label: recipe.label, image: recipe.image, ingredientLines: recipe.ingredientLines, url: recipe.url, totalTime: recipe.totalTime, foodIngredients: recipe.foodIngredients, context: appTestContext!)
        let x = dataController.fetch(context: appTestContext!)
        print(x)
        //then
        XCTAssertEqual(x?.last!.label, recipe.label)
        
    }
    
    func testRemoveFromFavorite() {
        
    }
    
    func testDownloadImage() {
        
    }
    
}

//extension CoreDataTestCase {
//    private func refreshTodoObjects() {
//        self.favTestRecipes = []
//        dataController.fetch { (result) in
//            let nsObjects =  try! result.get()!
//            self.favTestRecipes.append(contentsOf: nsObjects.map { $0 }
//            )
//        }
//    }
//}
