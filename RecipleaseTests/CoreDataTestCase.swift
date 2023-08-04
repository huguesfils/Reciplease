//
//  CoreDataTestCase.swift
//  RecipleaseTests
//
//  Created by Hugues Fils on 02/08/2023.
//

import XCTest
@testable import Reciplease
import CoreData

class TestCoreDataStack: NSObject {
    lazy var persistentContainer: NSPersistentContainer = {
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        let container = NSPersistentContainer(name: "Reciplease")
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
}

final class CoreDataTestCase: XCTestCase {

    func testAddFavoriteToCoreData() throws {
        //given
                let context = TestCoreDataStack().persistentContainer.newBackgroundContext()
            expectation(forNotification: .NSManagedObjectContextDidSave, object: context) { _ in
                return true
            }
        
    }
}
