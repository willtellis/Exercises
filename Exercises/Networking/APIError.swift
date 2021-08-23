//
//  APIError.swift
//  Exercises
//
//  Created by William Ellis on 8/22/21.
//

import Foundation

enum APIError: Error {
    case requestFailure
    case noData
    case badData
}
