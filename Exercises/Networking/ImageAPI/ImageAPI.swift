//
//  ImageAPI.swift
//  Exercises
//
//  Created by William Ellis on 8/22/21.
//

import Foundation
import UIKit

class ImageAPI {
    private let urlSession: URLSessionType

    // Inject the shared URLSession as the default
    init(urlSession: URLSessionType = URLSession.shared) {
        self.urlSession = urlSession
    }

    func imageTask(url: URL, completion: @escaping (Result<UIImage, APIError>) -> Void) -> URLSessionDataTask {
        let urlRequest = URLRequest(url: url)
        return urlSession.dataTask(with: urlRequest) { (data, urlResponse, error) in
            DispatchQueue.main.async {
                if error != nil {
                    completion(.failure(.requestFailure))
                    return
                }

                guard let data = data else {
                    completion(.failure(.noData))
                    return
                }

                guard let image = UIImage(data: data) else {
                    completion(.failure(.badData))
                    return
                }
                completion(.success(image))
            }
        }
    }
}
