//
//  PlantStruct.swift
//  PlantDiscover
//
//  Created by Дмитрий on 28/01/2021.
//  Copyright © 2021 Дмитрий. All rights reserved.
//

import Foundation

struct PlantsListResponse: Decodable {
    let data: [Plant]
    var total: Int
    
    enum CodingKeys: String, CodingKey {
        case data
        case meta
    }
    
    enum MetaCodingKeys: String, CodingKey {
        case total
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decode([Plant].self, forKey: .data)

        let metaContainer = try container.nestedContainer(keyedBy: MetaCodingKeys.self, forKey: .meta)
        self.total = try metaContainer.decode(Int.self, forKey: .total)
    }

}

struct Plant: Codable {
    let id: Int
    let commonName: String?
    let scientificName: String?
    let year: Int?
    let bibliography: String?
    let author: String?
    let status: String?
    let rank: String?
    let familyCommonName: String?
    let imageUrl: String?
    
    var isFavourite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case year
        case bibliography
        case author
        case status
        case rank
        
        case commonName = "common_name"
        case scientificName = "scientific_name"
        case familyCommonName = "family_common_name"
        case imageUrl = "image_url"
    }
}
