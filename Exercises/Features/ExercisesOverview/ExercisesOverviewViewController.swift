//
//  ExercisesOverviewViewController.swift
//  Exercises
//
//  Created by William Ellis on 8/22/21.
//

import UIKit

class ExercisesOverviewViewController: UITableViewController {

    enum SegueID: String {
        case exerciseDetail
    }

    enum CellID {
        static let exerciseCell = "exerciseOverviewCell"
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Exercises", comment: "Exercises overview screen title")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier,
              let segueID = SegueID(rawValue: identifier)
        else {
            return
        }

        switch (segueID, segue.destination, sender) {
        case let (.exerciseDetail, controller as ExerciseDetailViewController, indexPath as IndexPath):
            controller.title = "Row: \(indexPath.row)"

        default:
            break
        }
    }

    // MARK: UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10 // TODO
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID.exerciseCell, for: indexPath)
        guard let exerciseOverviewCell = cell as? ExerciseOverviewCell else {
            return cell
        }

        exerciseOverviewCell.configure(with: .init(
            exerciseImageURL: URL(string: "https://d32oopmphic0po.cloudfront.net/v1/images/body/en-US/body-exercise-4-14.png"),
            title: "Move hip",
            isFavorite: false
        ))

        return exerciseOverviewCell
    }

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: SegueID.exerciseDetail.rawValue, sender: indexPath)
    }
}
