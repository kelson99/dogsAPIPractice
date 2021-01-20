//
//  SavedDog+Convenience.swift
//  DogApiReview
//
//  Created by Kelson Hartle on 1/20/21.
//

import Foundation
import CoreData


extension SavedDog {
    
    convenience init(breed: String,
                     dogPhoto: Data?,
                     context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        self.breed = breed
        self.dogPhoto = dogPhoto
    }
}
