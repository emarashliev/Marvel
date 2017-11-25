//
//  Comics.swift
//  Marvel
//
//  Created by Emil Marashliev on 10/30/17.
//  Copyright © 2017 Emil Marashliev. All rights reserved.
//

import Foundation

struct Comics {
    var comicsId: Int?
    var title: String?
    var comicsDescription: String?
    var thumbnail: String?
    var characters: [Character]?

    enum CodingKeys: String, CodingKey {
        case comicsId = "id"
        case title
        case description
        case thumbnail
        case characters

    }

    enum ThumbnailKeys: String, CodingKey {
        case path
        case `extension`
    }

    enum CharactersKeys: String, CodingKey {
        case items
    }

}

extension Comics: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        comicsId = try values.decode(Int?.self, forKey: .comicsId)
        title = try values.decode(String?.self, forKey: .title)
        comicsDescription = try values.decode(String?.self, forKey: .description)
        let thumbnailKeys = try values.nestedContainer(keyedBy: ThumbnailKeys.self, forKey: .thumbnail)
        let path = try thumbnailKeys.decode(String.self, forKey: .path)
        let `extension` = try thumbnailKeys.decode(String.self, forKey: .extension)
        thumbnail = "\(path)/landscape_amazing.\(`extension`)"
        let characterItems = try values.nestedContainer(keyedBy: CharactersKeys.self, forKey: .characters)
        characters = try characterItems.decodeIfPresent([Character].self, forKey: .items)
    }

}
