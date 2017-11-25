//
//  Character.swift
//  Marvel
//
//  Created by Emil Marashliev on 10/30/17.
//  Copyright © 2017 Emil Marashliev. All rights reserved.
//

import Foundation

struct Character {
    var name: String?
    var resourceURI: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case resourceURI
    }
}

extension Character: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String?.self, forKey: .name)
        resourceURI = try values.decode(String?.self, forKey: .resourceURI)
    }

}
