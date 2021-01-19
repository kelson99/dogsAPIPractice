//
//  DogData.swift
//  DogApiReview
//
//  Created by Kelson Hartle on 1/18/21.
//

import Foundation

struct Dogs : Codable {
    let message: [String: [String]]
    let status: String
}


struct DogImages : Codable {
    let message: [String]
}
