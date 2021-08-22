//
//  ExercisesOverviewViewController.swift
//  Exercises
//
//  Created by William Ellis on 8/22/21.
//

import UIKit

class ExercisesOverviewViewController: UIViewController {

    // MARK: Constants

    enum SegueID: String {
        case exercise
    }

    // Mark: - Outlets

    @IBOutlet private weak var startTrainingButton: UIButton!

    // MARK: - Lifecycle methods

    override func viewDidLoad() {
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
            // TODO: Inject data
            break

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

    @IBAction func unwindAction(unwindSegue: UIStoryboardSegue) {
    }
}
