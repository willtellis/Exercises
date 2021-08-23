//
//  ExercisesOverviewTableViewCell.swift
//  Exercises
//
//  Created by William Ellis on 8/22/21.
//

import UIKit

protocol ExercisesOverviewTableViewCellDelegate: AnyObject {
    func didUpdateModel(_ model: ExercisesOverviewTableViewCell.Model, for cell: ExercisesOverviewTableViewCell)
}

class ExercisesOverviewTableViewCell: UITableViewCell {

    typealias Model = ExerciseEntity

    // MARK: - Public attributes

    weak var delegate: ExercisesOverviewTableViewCellDelegate?

    // MARK: - Private attributes

    private var model: Model?
    private var imageTask: URLSessionDataTask?

    // MARK: - Outlets

    @IBOutlet private weak var exerciseImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var favoriteButton: UIButton!

    // MARK: - Overrides

    override func prepareForReuse() {
        imageTask?.cancel()
        imageTask = nil
        delegate = nil
        model = nil
    }

    // MARK: - Public instance methods

    func configure(with model: Model) {
        self.model = model
        let url = model.coverImageURL.flatMap { URL(string: $0) }
        configureExerciseImage(with: url)
        titleLabel.text = model.name
        let image = model.isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        favoriteButton.setImage(image, for: .normal)
    }

    private func configureExerciseImage(with url: URL?) {
        imageTask?.cancel()
        imageTask = nil
        exerciseImageView.image = nil
        guard let url = url else {
            return
        }
        imageTask = ImageAPI().imageTask(url: url) { [weak self] result in
            guard let self = self, case .success(let image) = result else {
                return
            }
            self.exerciseImageView?.image = image
        }
        imageTask?.resume()
    }

    // MARK: - Actions

    @IBAction private func didPressFavoriteButton(_ sender: Any) {
        guard let model = model else {
            return
        }
        model.isFavorite.toggle()
        delegate?.didUpdateModel(model, for: self)
    }
}
