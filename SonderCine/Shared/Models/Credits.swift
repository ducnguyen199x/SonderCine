//
//  Credit.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 28/8/21.
//

import Foundation

struct Credit: Decodable {
    var id: Int
    var cast: [Cast]?
    var crew: [Crew]?
}

struct Cast: Decodable {
    var id: Int
    @StringValue var name: String
    @StringValue var character: String
}

struct Crew: Decodable {
    var id: Int
    @StringValue var name: String
    var job: Job
}

extension Crew {
    enum Job: String, Decodable {
        case director = "Director"
        case assistantDirector = "Assistant Director"
        case photographyDirector = "Director of Photography"
        case other
        
        init(from decoder: Decoder) throws {
            if let value = try? decoder.singleValueContainer().decode(String.self) {
                self = .init(rawValue: value) ?? .other
            } else {
                self = .other
            }
        }
    }
}
