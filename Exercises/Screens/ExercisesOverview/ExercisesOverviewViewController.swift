//
//  ExercisesOverviewViewController.swift
//  Exercises
//
//  Created by William Ellis on 8/22/21.
//

import UIKit
import CoreData

class ExercisesOverviewViewController: UIViewController {

    // MARK: Constants

    enum SegueID: String {
        case exercise
        case exercisesOverviewTable
    }

    // MARK: - Public attributes

    var context: NSManagedObjectContext?

    // MARK: - Outlets

    @IBOutlet private weak var startTrainingButton: UIButton!

    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        configureStartTrainingButton()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier,
              let segueID = SegueID(rawValue: identifier)
        else {
            return
        }

        switch (segueID, segue.destination) {
        case let (.exercise, controller as ExerciseViewController):
            controller.context = context

        case let (.exercisesOverviewTable, controller as ExercisesOverviewTableViewController):
            controller.additionalSafeAreaInsets.bottom = 54 // Additional space for the start button
            controller.context = context

        default:
            break
        }
    }

    // MARK: - Private instance methods

    func configureStartTrainingButton() {
        startTrainingButton.tintColor = .white
        startTrainingButton.layer.cornerRadius = 4.0
        startTrainingButton.backgroundColor = .systemGreen
        let title = NSLocalizedString("Start training", comment: "Start training button title")
        startTrainingButton.setTitle(title, for: .normal)
    }

    // MARK: - Actions

    /// Allows a presented view controller to request dismissal without dismissing itself or explicitly referencing its presenting view controller
    @IBAction private func unwindAction(unwindSegue: UIStoryboardSegue) {
        // Nothing to do, intentionally empty
    }
}
