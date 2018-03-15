//
//  CoreDataStack.swift
//  Dog Walk
//
//  Created by Yung Dai on 2016-10-09.
//  Copyright © 2016 Razeware. All rights reserved.
//

import Foundation
import CoreData

public class CoreDataStack {
    
    private let modelName: String
    
    public init(modelName: String) {
        self.modelName = modelName
    }
    
    // instatiate a NSPersistentConainter with the model name
    private lazy var storeContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    
    // return the new container's viewcontext as your managed contexted
    public lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    
    // convenience method to save stack's managed object conext and handel any errors.
    public func saveContext() {
        
        guard managedContext.hasChanges else { return }
        
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
}
