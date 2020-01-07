//
//  Planet.swift
//  starship-shopper
//
//  Created by Charlie Quinn on 1/5/20.
//  Copyright © 2020 Charlie Quinn's Personal Projects. All rights reserved.
//

import Foundation

struct Planet: Decodable {
    let name: String
    let climate: String
    let diameter: String
    let gravity: String
    let rotation_period: String
    let orbital_period: String
    let population: String
    let surface_water: String
    let terrain: String
}

extension Planet: SearchResult {
    func Title() -> String {
        return self.name
    }
    
    func Type() -> String {
        return "Planet"
    }
}

struct PlanetResponse: Decodable {
    let results: [Planet]
    let count: Int
    let next: String?
    let previous: String?
}
