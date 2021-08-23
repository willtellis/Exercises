//
//  ExercisesAPITests.swift
//  ExercisesTests
//
//  Created by William Ellis on 8/23/21.
//

@testable import Exercises
import XCTest

class ExercisesAPITests: XCTestCase {

    // Force unwrap known good test data objects
    let url = URL(string: "https://www.example.com")!
    let exercisesData = (try? JSONEncoder().encode(Array.mockExercises))!
    let badExerciseData = "Not exercises".data(using: .utf8)!

    func testExerciseTask_NoErrorWithData_CompletesWithSuccess() throws {
        let mockSession = MockURLSession(data: exercisesData, urlResponse: nil, error: nil)
        let expectation = XCTestExpectation(description: "Expected to complete successfully")
        let task = ExercisesAPI(urlSession: mockSession).exercisesTask { result in
            guard case .success = result else {
                XCTFail("Expected data")
                return
            }
            expectation.fulfill()
        }
        task.resume()
        wait(for: [expectation], timeout: 3.0)
    }

    func testExerciseTask_NetworkError_CompletesWithRequestFailure() throws {
        let mockSession = MockURLSession(data: nil, urlResponse: nil, error: MockNetworkError())
        let expectation = XCTestExpectation(description: "Expected to complete successfully")
        let task = ExercisesAPI(urlSession: mockSession).exercisesTask { result in
            guard case .failure(.requestFailure) = result else {
                XCTFail("Expected request failure")
                return
            }
            expectation.fulfill()
        }
        task.resume()
        wait(for: [expectation], timeout: 3.0)
    }

    func testExerciseTask_NoErrorNoData_CompletesWithNoDataFailure() throws {
        let mockSession = MockURLSession(data: nil, urlResponse: nil, error: nil)
        let expectation = XCTestExpectation(description: "Expected to complete successfully")
        let task = ExercisesAPI(urlSession: mockSession).exercisesTask { result in
            guard case .failure(.noData) = result else {
                XCTFail("Expected no data")
                return
            }
            expectation.fulfill()
        }
        task.resume()
        wait(for: [expectation], timeout: 3.0)
    }

    func testExerciseTask_NoErrorBadData_CompletesWithRequestFailure() throws {
        let mockSession = MockURLSession(data: badExerciseData, urlResponse: nil, error: nil)
        let expectation = XCTestExpectation(description: "Expected to complete successfully")
        let task = ExercisesAPI(urlSession: mockSession).exercisesTask { result in
            guard case .failure(.badData) = result else {
                XCTFail("Expected bad data")
                return
            }
            expectation.fulfill()
        }
        task.resume()
        wait(for: [expectation], timeout: 3.0)
    }
}

private extension Array where Element == Exercise {
    static var mockExercises: Array<Element> {
        return [
            Exercise(id: 1, name: "Name", coverImageURL: "https://www.example.com")
        ]
    }
}
