//
//  ImageFetcherTests.swift
//  ExercisesTests
//
//  Created by William Ellis on 8/22/21.
//

@testable import Exercises
import XCTest

class ImageFetcherTests: XCTestCase {

    // Force unwrap known good test data objects
    let url = URL(string: "https://www.example.com")!
    let imageData = UIImage(systemName: "star")!.pngData()!
    let badImageData = "Not an image".data(using: .utf8)!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testfetchImageTask_NoErrorWithData_CompletesWithSuccess() throws {
        let mockSession = MockImageFetcherSession(data: imageData, urlResponse: nil, error: nil)
        let expectation = XCTestExpectation(description: "Expected to complete successfully")
        let task = ImageFetcher(imageFetcherSession: mockSession).fetchImageTask(url: url) { result in
            guard case .success = result else {
                XCTFail("Expected data")
                return
            }
            expectation.fulfill()
        }
        task.resume()
        wait(for: [expectation], timeout: 3.0)
    }

    func testfetchImageTask_NetworkError_CompletesWithRequestFailure() throws {
        let mockSession = MockImageFetcherSession(data: nil, urlResponse: nil, error: MockNetworkError())
        let expectation = XCTestExpectation(description: "Expected to complete successfully")
        let task = ImageFetcher(imageFetcherSession: mockSession).fetchImageTask(url: url) { result in
            guard case .failure(.requestFailure) = result else {
                XCTFail("Expected request failure")
                return
            }
            expectation.fulfill()
        }
        task.resume()
        wait(for: [expectation], timeout: 3.0)
    }

    func testfetchImageTask_NoErrorNoData_CompletesWithNoDataFailure() throws {
        let mockSession = MockImageFetcherSession(data: nil, urlResponse: nil, error: nil)
        let expectation = XCTestExpectation(description: "Expected to complete successfully")
        let task = ImageFetcher(imageFetcherSession: mockSession).fetchImageTask(url: url) { result in
            guard case .failure(.noData) = result else {
                XCTFail("Expected no data")
                return
            }
            expectation.fulfill()
        }
        task.resume()
        wait(for: [expectation], timeout: 3.0)
    }

    func testfetchImageTask_NoErrorBadData_CompletesWithRequestFailure() throws {
        let mockSession = MockImageFetcherSession(data: badImageData, urlResponse: nil, error: nil)
        let expectation = XCTestExpectation(description: "Expected to complete successfully")
        let task = ImageFetcher(imageFetcherSession: mockSession).fetchImageTask(url: url) { result in
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

private struct MockNetworkError: Error {
}

private struct MockImageFetcherSession: ImageFetcherSession {
    let data: Data?
    let urlResponse: URLResponse?
    let error: Error?
    init(data: Data?, urlResponse: URLResponse?, error: Error?) {
        self.data = data
        self.urlResponse = urlResponse
        self.error = error
    }

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return MockImageFetcherDataTask(completion: {
            completionHandler(data, urlResponse, error)
        })
    }
}

private class MockImageFetcherDataTask: URLSessionDataTask {
    private let completion: () -> Void

    init(completion: @escaping () -> Void) {
        self.completion = completion
    }

    override func resume() {
        completion()
    }
}
