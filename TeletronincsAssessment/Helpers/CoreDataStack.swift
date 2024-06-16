//
//  CoreDataStack.swift
//  TeletronincsAssessment
//
//  Created by Lizan on 15/06/2024.
//

import Foundation
import CoreData
import Combine

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")!
}

class CoreDataStack {
    static let shared = CoreDataStack()

    // Persistent container for CoreData
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TeletronicsAssessment")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType // Use in-memory store for testing
        container.persistentStoreDescriptions = [description]
        
        // Load persistent stores asynchronously
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Failed to load in-memory store: \(error)")
            }
        }
        return container
    }()

    // Managed object context for main queue
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // Save changes to the context
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
    }

    // Fetch all PostEntity objects
    func fetchPostEntities() -> AnyPublisher<[PostEntity], Error> {
        let fetchRequest: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()

        return Future<[PostEntity], Error> { promise in
            do {
                let entities = try self.context.fetch(fetchRequest)
                promise(.success(entities))  // Fulfill promise with fetched entities
            } catch {
                promise(.failure(error))  // Propagate fetch error through promise
            }
        }
        .eraseToAnyPublisher()  // Type-erase publisher to hide implementation details
    }
    
    // Clear all data from CoreData
    func clearAllData() -> AnyPublisher<Void, Error> {
        let entities = [PostEntity.self, AlbumEntity.self, PhotoEntity.self]
        
        return Publishers.MergeMany(entities.map { entity in
            self.deleteAll(for: entity)
        })
        .collect()
        .map { _ in () }
        .eraseToAnyPublisher()
    }
    
    private func deleteAll<T: NSManagedObject>(for entityType: T.Type) -> AnyPublisher<Void, Error> {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = entityType.fetchRequest()
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        return Future<Void, Error> { promise in
            do {
                try self.context.execute(batchDeleteRequest)
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}
