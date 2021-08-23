//
//  ExercisesOverviewTableViewController.swift
//  Exercises
//
//  Created by William Ellis on 8/22/21.
//

import CoreData
import UIKit

class ExercisesOverviewTableViewController: UITableViewController,
                                            ExercisesOverviewTableViewCellDelegate,
                                            NSFetchedResultsControllerDelegate {

    enum CellID {
        static let exercisesOverviewTableViewCell = "exercisesOverviewTableViewCell"
    }

    // MARK: - Public attributes

    /// Managed object context for accessing ExerciseEntities. Must be set before loading the view.
    var context: NSManagedObjectContext!

    // MARK: - Private attributes

    private lazy var fetchedResultsController = NSFetchedResultsController<ExerciseEntity>.controller(with: context)

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            fetchedResultsController.delegate = self
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Core Data fetch error")
        }
    }

    // MARK: UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else {
            return 0
        }
        return sectionInfo.numberOfObjects
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID.exercisesOverviewTableViewCell, for: indexPath)
        guard let exercisesOverviewTableViewCell = cell as? ExercisesOverviewTableViewCell else {
            return cell
        }

        let exerciseEntity = fetchedResultsController.object(at: indexPath)
        exercisesOverviewTableViewCell.configure(with: exerciseEntity)

        return exercisesOverviewTableViewCell
    }

    // MARK: - ExercisesOverviewTableViewCellDelegate

    func didUpdateModel(_ model: ExercisesOverviewTableViewCell.Model, for cell: ExercisesOverviewTableViewCell) {
        do {
            try context.save()
        } catch {
            fatalError("Core Data error")
        }
    }

    // MARK: - NSFetchedResultsControllerDelegate

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch (type, indexPath, newIndexPath) {
        case (.insert, _, .some(let newIndexPath)):
            tableView.insertRows(at: [newIndexPath], with: .fade)

        case (.delete, .some(let indexPath), _):
            tableView.deleteRows(at: [indexPath], with: .fade)

        case (.move, .some(let indexPath), .some(let newIndexPath)):
            tableView.moveRow(at: indexPath, to: newIndexPath)

        case (.update, .some(let indexPath), _):
            tableView.reloadRows(at: [indexPath], with: .fade)

        default:
            break
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
