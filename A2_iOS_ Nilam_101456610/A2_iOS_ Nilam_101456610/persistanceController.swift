//
//  persistanceController.swift
//  A2_iOS_ Nilam_101456610
//
import CoreData

// PersistenceController will be used to manage Core Data
class PersistenceController {
    
    // Shared instance for global access
    static let shared = PersistenceController()
    
    // The persistent container for the app. It contains the Core Data stack.
    let container: NSPersistentContainer
    
    // Initializer for setting up the Core Data stack
    init() {
        // Replace "YourModelName" with the name of your .xcdatamodeld file (without the extension)
        container = NSPersistentContainer(name: "YourModelName") // Your .xcdatamodeld file name
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error.localizedDescription)")
            }
        }
    }
    
    // Save the context if there are changes
    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}


