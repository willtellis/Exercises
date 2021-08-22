//
//  Network.swift
//  Exercises
//
//  Created by William Ellis on 8/22/21.
//

import Foundation
import UIKit

enum ImageFetcherError: Error {
    case requestFailure
    case noData
    case badData
}

class ImageFetcher {
    private let imageFetcherSession: ImageFetcherSession

    // Inject the shared URLSession as the default
    init(imageFetcherSession: ImageFetcherSession = URLSession.shared) {
        self.imageFetcherSession = imageFetcherSession
    }

    func fetchImageTask(url: URL, completion: @escaping (Result<UIImage, ImageFetcherError>) -> Void) -> URLSessionDataTask {
        let urlRequest = URLRequest(url: url)
        return imageFetcherSession.dataTask(with: urlRequest) { (data, urlResponse, error) in
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
