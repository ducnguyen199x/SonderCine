//
//  Credit.swift
//  SonderCine
//
//  Created by Nguyen Thanh Duc on 28/8/21.
//

import Foundation

protocol CastOrCrew {
    var id: Int { get set }
    var name: String { get set }
    var profilePath: String? { get set }
    var role: String { get }
}

struct Credit: Decodable, CoordinatorPayload {
    var id: Int
    var cast: [Cast]?
    var crew: [Crew]?
}

struct Cast: CastOrCrew, Decodable {
    var id: Int
    @StringValue var name: String
    @StringValue var character: String
    var profilePath: String?
    var role: String {
        character
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, character
        case profilePath = "profile_path"
    }
}

struct Crew: CastOrCrew, Decodable {
    var id: Int
    @StringValue var name: String
    var profilePath: String?
    var job: Job
    var role: String {
        job.description
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, job
        case profilePath = "profile_path"
    }
}

extension Crew {
    enum Job: Decodable {
        case director
        case photographyDirector
        case other(String)
        
        init(from decoder: Decoder) throws {
            if let value = try? decoder.singleValueContainer().decode(String.self) {
                switch value {
                case "Director": self = .director
                case "Director of Photography": self = .photographyDirector
                default: self = .other(value)
                }
            } else {
                self = .other("")
            }
        }
        
        var isDirector: Bool {
            switch self {
            case .director, .photographyDirector: return true
            default: return false
            }
        }
        
        var description: String {
            switch self {
            case .director: return "Director"
            case .photographyDirector: return "Director of Photography"
            case let .other(job): return job
            }
        }
    }
}
