//
//  AgeAPIResponse.swift
//  DevInterviewApp
//
//  Created by Vincent Zhou on 9/15/22.
//

import Foundation

struct AgeAPIResponse: Codable {
    var name: String
    var age: Int
    var count: Int
    var country_id: String
}
