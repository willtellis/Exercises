//
//  ExercisesAPI.swift
//  Exercises
//
//  Created by William Ellis on 8/22/21.
//

import Foundation

/// Responsible for requesting exercise API data
class ExercisesAPI {
    // MARK: - Constants
    enum Constants {
        static let url = URL(string: "https://jsonblob.com/api/jsonBlob/d92ee4cd-dff6-11eb-a8ab-05b78a9f1668")!
    }

    private let urlSession: URLSessionType

    // Inject the shared URLSession as the default
    init(urlSession: URLSessionType = URLSession.shared) {
        self.urlSession = urlSession
    }

    func exercisesTask(completion: @escaping (Result<[Exercise], APIError>) -> Void) -> URLSessionDataTask {
        let urlRequest = URLRequest(url: Constants.url)
        return urlSession.dataTask(with: urlRequest) { (data, urlResponse, error) in
            if error != nil {
                completion(.failure(.requestFailure))
                return
            }

            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            guard let exercises = try? JSONDecoder().decode(Array<Exercise>.self, from: data) else {
                completion(.failure(.badData))
                return
            }
            completion(.success(exercises))
        }
    }
}
