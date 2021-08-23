//
//  Exercise.swift
//  Exercises
//
//  Created by William Ellis on 8/22/21.
//

import Foundation

struct Exercise: Decodable {
    let id: Int
    let name: String?
    let coverImageURL: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case coverImageURL = "cover_image_url"
    }
}
