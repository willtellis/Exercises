//
//  ExerciseViewController.swift
//  Exercises
//
//  Created by William Ellis on 8/22/21.
//

import UIKit

class ExerciseViewController: UIViewController {

    struct Model {
        let exerciseImageURL: URL?
        let title: String?
        var isFavorite: Bool

        static var initial: Self {
            return .init(exerciseImageURL: nil, title: nil, isFavorite: false)
        }
    }

    // MARK: - Private attributes

    var model: Model = .initial

    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var favoriteButton: UIButton!

    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCancelButton()
        configureFavoriteButton()
    }

    // MARK: - Public instance methods

    func configure(with model: Model) {
        self.model = model

    }

    private func configureCancelButton() {
        cancelButton.tintColor = .white
        cancelButton.layer.cornerRadius = 4.0
        cancelButton.backgroundColor = .systemRed
        let title = NSLocalizedString("Cancel training", comment: "Cancel training button title")
        cancelButton.setTitle(title, for: .normal)
    }

    private func configureFavoriteButton() {
        let title: String
        if model.isFavorite {
            title = NSLocalizedString("Unfavorite exercise", comment: "Favorite exercise button title")
        } else {
            title = NSLocalizedString("Favorite exercise", comment: "Unfavorite exercise button title")
        }
        favoriteButton.tintColor = .white
        favoriteButton.layer.cornerRadius = 4.0
        favoriteButton.backgroundColor = .systemBlue
        favoriteButton.setTitle(title, for: .normal)
    }

    // MARK: - Actions

    @IBAction private func favoriteButtonPressed(_ sender: Any) {
        model.isFavorite.toggle()
        configureFavoriteButton()
    }
}
