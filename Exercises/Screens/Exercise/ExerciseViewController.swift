//
//  ExerciseViewController.swift
//  Exercises
//
//  Created by William Ellis on 8/22/21.
//

import CoreData
import UIKit

/// Displays the exercises one a time in sequence
class ExerciseViewController: UIViewController {
    // MARK: - Public attributes

    /// Managed object context for accessing ExerciseEntities. Must be set before loading the view.
    var context: NSManagedObjectContext!

    // MARK: - Private attributes

    private lazy var fetchedResultsController = NSFetchedResultsController<ExerciseEntity>.controller(with: context)
    private var exerciseEntities: [ExerciseEntity]?

    // Timer and timer management
    private var timer: Timer?
    private var currentExerciseEntity: ExerciseEntity?
    private var nextExerciseEntityIndex = 0

    // Task for downloading the image
    private var imageTask: URLSessionDataTask?

    // MARK: - Outlets

    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private weak var exerciseImageView: UIImageView!

    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCancelButton()
        do {
            try fetchedResultsController.performFetch()
            exerciseEntities = fetchedResultsController.fetchedObjects
            configureTimer()
        } catch {
            fatalError("Core Data fetch error")
        }
    }

    // MARK: - Private instance methods

    private func configureTimer() {
        nextExerciseEntityIndex = 0
        let timer = Timer(fire: Date(), interval: 5.0, repeats: true) { [weak self] timer in
            guard let self = self, let exerciseEntities = self.exerciseEntities else {
                timer.invalidate()
                return
            }
            let index = self.nextExerciseEntityIndex
            self.nextExerciseEntityIndex = (index + 1) % exerciseEntities.count
            let exerciseEntity = exerciseEntities[index]
            self.currentExerciseEntity = exerciseEntity
            self.configure(with: exerciseEntity)
        }
        RunLoop.current.add(timer, forMode: .default)
        self.timer = timer
    }

    private func configure(with exerciseEntity: ExerciseEntity) {
        configureFavoriteButton(isFavorite: exerciseEntity.isFavorite)
        let url = exerciseEntity.coverImageURL.flatMap { URL(string: $0) }
        configureExerciseImage(url: url)
    }

    private func configureCancelButton() {
        cancelButton.tintColor = .white
        cancelButton.layer.cornerRadius = 4.0
        cancelButton.backgroundColor = .systemRed
        let title = NSLocalizedString("Cancel training", comment: "Cancel training button title")
        cancelButton.setTitle(title, for: .normal)
    }

    private func configureFavoriteButton(isFavorite: Bool) {
        let title: String
        if isFavorite {
            title = NSLocalizedString("Unfavorite exercise", comment: "Favorite exercise button title")
        } else {
            title = NSLocalizedString("Favorite exercise", comment: "Unfavorite exercise button title")
        }
        favoriteButton.tintColor = .white
        favoriteButton.layer.cornerRadius = 4.0
        favoriteButton.backgroundColor = .systemBlue
        favoriteButton.setTitle(title, for: .normal)
    }

    private func configureExerciseImage(url: URL?) {
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

    @IBAction private func favoriteButtonPressed(_ sender: Any) {
        currentExerciseEntity?.isFavorite.toggle()
        do {
            try context?.save()
        } catch {
            fatalError("Core Data error")
        }
        if let isFavorite = currentExerciseEntity?.isFavorite {
            configureFavoriteButton(isFavorite: isFavorite)
        }
    }
}
