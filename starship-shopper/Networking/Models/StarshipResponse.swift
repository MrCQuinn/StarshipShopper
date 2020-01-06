//
//  PagedStarshipResponse.swift
//  starship-shopper
//
//  Created by Charlie Quinn on 12/28/19.
//  Copyright © 2019 Charlie Quinn's Personal Projects. All rights reserved.
//

import Foundation

struct StarshipResponse: Decodable {
    let starships: [Starship]
    let count: Int
    let next: String?
    let previous: String?
    
    enum CodingKeys: String, CodingKey {
        case starships = "results"
        case count
        case next
        case previous
    }
}
