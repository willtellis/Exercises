//
//  ImageAPITests.swift
//  ExercisesTests
//
//  Created by William Ellis on 8/22/21.
//

@testable import Exercises
import XCTest

class ImageAPITests: XCTestCase {

    // Force unwrap known good test data objects
    let url = URL(string: "https://www.example.com")!
    let imageData = UIImage(systemName: "star")!.pngData()!
    let badImageData = "Not an image".data(using: .utf8)!

    func testImageTask_NoErrorWithData_CompletesWithSuccess() throws {
        let mockSession = MockURLSession(data: imageData, urlResponse: nil, error: nil)
        let expectation = XCTestExpectation(description: "Expected to complete successfully")
        let task = ImageAPI(urlSession: mockSession).imageTask(url: url) { result in
            guard case .success = result else {
                XCTFail("Expected data")
                return
            }
            expectation.fulfill()
        }
        task.resume()
        wait(for: [expectation], timeout: 3.0)
    }

    func testImageTask_NetworkError_CompletesWithRequestFailure() throws {
        let mockSession = MockURLSession(data: nil, urlResponse: nil, error: MockNetworkError())
        let expectation = XCTestExpectation(description: "Expected to complete successfully")
        let task = ImageAPI(urlSession: mockSession).imageTask(url: url) { result in
            guard case .failure(.requestFailure) = result else {
                XCTFail("Expected request failure")
                return
            }
            expectation.fulfill()
        }
        task.resume()
        wait(for: [expectation], timeout: 3.0)
    }

    func testImageTask_NoErrorNoData_CompletesWithNoDataFailure() throws {
        let mockSession = MockURLSession(data: nil, urlResponse: nil, error: nil)
        let expectation = XCTestExpectation(description: "Expected to complete successfully")
        let task = ImageAPI(urlSession: mockSession).imageTask(url: url) { result in
            guard case .failure(.noData) = result else {
                XCTFail("Expected no data")
                return
            }
            expectation.fulfill()
        }
        task.resume()
        wait(for: [expectation], timeout: 3.0)
    }

    func testImageTask_NoErrorBadData_CompletesWithRequestFailure() throws {
        let mockSession = MockURLSession(data: badImageData, urlResponse: nil, error: nil)
        let expectation = XCTestExpectation(description: "Expected to complete successfully")
        let task = ImageAPI(urlSession: mockSession).imageTask(url: url) { result in
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
