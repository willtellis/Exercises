# Exercises
An app for viewing exercises and favoriting them

## Architecture
This app follows the Model View Controller design pattern. `UIView` objects and `UIViewController` objects are the views and controllers in this implementation of the pattern. Local data persistance being a requirement of this app, managed objects provided by a CoreData `NSManagedObjectContext` represent the models.

## Screens
Each screen is represented by a top level view controller and accompanying storyboard. Complexity on a screen is managed by modularizing functionality into child view controllers. For example, the `ExercisesOverviewViewController` has a child `ExercisesOverviewTableViewController` that manages the table view.

## Networking
This app fetches exercise data from a network endpoint on startup using the `ExercisesAPI` type. This app also fetches exercise images using the `ImageAPI` type.

## CoreData
In order to support local storage of user favorites, this app implements a CoreData stack.  User favorites are stored and retrieved as the `ExerciseEntity` managed objects. For convenience, data retrieved using the `ExercisesAPI` is also stored in the same managed objects, however, this API data is refetched every time the app is run. 

## ExercisesDataManager
The `ExerciseDataManager` is responsible for retrieving exercise data using the `ExercisesAPI` and adding to or updating the `ExerciseEntity` managed objects.

## Tests
The `ExercisesAPI` and `ImageAPI` networking types are each unit tested through mocking using the `URLSessionType` protocol.

## Open Issues
* The `ExercisesDataManager` could be unit tested.
* The `ExerciseViewController`'s timer functionality could be broken out and managed by a testable object.
* UI tests could be added to test happy path features
* CoreData errors could be handled more gracefully
