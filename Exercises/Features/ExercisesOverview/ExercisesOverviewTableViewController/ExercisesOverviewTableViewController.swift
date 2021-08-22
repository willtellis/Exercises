//
//  ExercisesOverviewTableViewController.swift
//  Exercises
//
//  Created by William Ellis on 8/22/21.
//

import UIKit

class ExercisesOverviewTableViewController: UITableViewController {

    enum CellID {
        static let exercisesOverviewTableViewCell = "exercisesOverviewTableViewCell"
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Exercises", comment: "Exercises overview screen title")
    }

    // MARK: UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10 // TODO
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID.exercisesOverviewTableViewCell, for: indexPath)
        guard let exercisesOverviewTableViewCell = cell as? ExercisesOverviewTableViewCell else {
            return cell
        }

        exercisesOverviewTableViewCell.configure(with: .init(
            exerciseImageURL: URL(string: "https://d32oopmphic0po.cloudfront.net/v1/images/body/en-US/body-exercise-4-14.png"),
            title: "Move hip",
            isFavorite: false
        ))

        return exercisesOverviewTableViewCell
    }
}
