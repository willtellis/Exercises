//
//  NSFetchedResultsControllerExtensions.swift
//  Exercises
//
//  Created by William Ellis on 8/23/21.
//

import CoreData

/// Convenience method fro creating the `NSFetchedResultsController<ExerciseEntity>`
extension NSFetchedResultsController where ResultType == ExerciseEntity {
    static func controller(with context: NSManagedObjectContext) -> NSFetchedResultsController<ResultType> {
        let fetchRequest: NSFetchRequest<ResultType> = ResultType.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "identifier", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: context,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        return controller
    }
}
