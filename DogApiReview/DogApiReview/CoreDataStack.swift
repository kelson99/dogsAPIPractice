//
//  CoreDataStack.swift
//  DogApiReview
//
//  Created by Kelson Hartle on 1/20/21.
//

import Foundation

import CoreData

class CoreDataStack {

    static let shared = CoreDataStack()

    lazy var container: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "DogApiReview")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        })
        return container
    }()

    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }

    func saveToPersistentStore() {
        do {
            try mainContext.save()
        } catch {
            NSLog("Error saving context: \(error)")
            mainContext.reset()
        }
    }
}
