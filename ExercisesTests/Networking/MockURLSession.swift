//
//  MockURLSession.swift
//  ExercisesTests
//
//  Created by William Ellis on 8/23/21.
//

import Foundation
@testable import Exercises

/// Implements `URLSessionType` for mocking
struct MockURLSession: URLSessionType {
    let data: Data?
    let urlResponse: URLResponse?
    let error: Error?
    init(data: Data?, urlResponse: URLResponse?, error: Error?) {
        self.data = data
        self.urlResponse = urlResponse
        self.error = error
    }

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return MockURLSessionDataTask(completion: {
            completionHandler(data, urlResponse, error)
        })
    }
}

/// Works with `MockURLSession` to provide a mock resonse without making an actual network call
class MockURLSessionDataTask: URLSessionDataTask {
    private let completion: () -> Void

    init(completion: @escaping () -> Void) {
        self.completion = completion
    }

    override func resume() {
        completion()
    }
}

/// Mock network error for setting on the `MockURLSession`
struct MockNetworkError: Error {}
