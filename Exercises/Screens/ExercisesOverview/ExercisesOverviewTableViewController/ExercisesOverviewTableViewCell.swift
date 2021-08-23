//
//  ExercisesOverviewTableViewCell.swift
//  Exercises
//
//  Created by William Ellis on 8/22/21.
//

import UIKit

class ExercisesOverviewTableViewCell: UITableViewCell {

    struct Model {
        let exerciseImageURL: URL?
        let title: String?
        let isFavorite: Bool
    }

    @IBOutlet private weak var exerciseImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var starImageView: UIImageView!

    private var fetchExerciseImageTask: URLSessionDataTask?

    // MARK: - Overrides

    override func prepareForReuse() {
        fetchExerciseImageTask?.cancel()
        fetchExerciseImageTask = nil
    }

    // MARK: - Public instance methods

    func configure(with model: Model) {
        configureExerciseImage(with: model.exerciseImageURL)
        titleLabel.text = model.title
    }

    private func configureExerciseImage(with url: URL?) {
        fetchExerciseImageTask?.cancel()
        fetchExerciseImageTask = nil
        exerciseImageView.image = nil
        guard let url = url else {
            return
        }
        fetchExerciseImageTask = ImageFetcher().fetchImageTask(url: url) { [weak self] result in
            guard let self = self, case .success(let image) = result else {
                return
            }
            self.exerciseImageView?.image = image
        }
        fetchExerciseImageTask?.resume()
    }
}
