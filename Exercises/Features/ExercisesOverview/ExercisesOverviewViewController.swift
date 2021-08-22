//
//  ExercisesOverviewViewController.swift
//  Exercises
//
//  Created by William Ellis on 8/22/21.
//

import UIKit

class ExercisesOverviewViewController: UITableViewController {
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("Exercises", comment: "Exercises overview screen title")
    }
}
