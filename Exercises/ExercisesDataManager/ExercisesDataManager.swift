//
//  ExercisesDataManager.swift
//  Exercises
//
//  Created by William Ellis on 8/22/21.
//

import CoreData
import Foundation

/// Responsible for requesting exercises API data and updating the Core Data model
class ExercisesDataManager: NSObject {
    /// The managed object context for the exercise Core Data entity objects
    let context: NSManagedObjectContext

    private lazy var fetchedResultsController = NSFetchedResultsController<ExerciseEntity>.controller(with: context)

    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }

    /// Fetches the ExerciseEntity objects, requests exercises API data, and updates the ExerciseEntity objects with that data.
    /// Updates can be observed using the `context`.
    func start() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Core Data fetch error")
        }

        guard let exerciseEntities = self.fetchedResultsController.fetchedObjects else {
            return
        }

        let request = ExercisesAPI().exercisesTask { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self, let exercises = try? result.get() else {
                    return
                }
                // For each retrieved exercise, update the corresponding entity if it exists or add a new entity
                for exercise in exercises {
                    if let exerciseEntity = exerciseEntities.first(where: { $0.identifier == Int64(exercise.id) }) {
                        exerciseEntity.name = exercise.name
                        exerciseEntity.coverImageURL = exercise.coverImageURL
                    } else {
                        let exerciseEntity = ExerciseEntity(context: self.context)
                        exerciseEntity.isFavorite = false
                        exerciseEntity.identifier = Int64(exercise.id)
                        exerciseEntity.name = exercise.name
                        exerciseEntity.coverImageURL = exercise.coverImageURL
                    }
                }
                do {
                    try self.context.save()
                } catch {
                    fatalError("Core Data save error")
                }
            }
        }
        request.resume()
    }
}
