//
//  PlanetResponse.swift
//  starship-shopper
//
//  Created by Charlie Quinn on 1/5/20.
//  Copyright © 2020 Charlie Quinn's Personal Projects. All rights reserved.
//

import Foundation

struct PlanetResponse: Decodable {
    let results: [Planet]
    let count: Int
    let next: String?
    let previous: String?
}
