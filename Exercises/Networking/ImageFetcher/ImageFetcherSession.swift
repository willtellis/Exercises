//
//  ImageFetcherSession.swift
//  Exercises
//
//  Created by William Ellis on 8/22/21.
//

import Foundation

/// Protocol to enable testing of ImageFetcher by mocking out URLSession
protocol ImageFetcherSession {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}
