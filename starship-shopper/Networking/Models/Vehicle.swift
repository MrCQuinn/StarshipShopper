//
//  Vehicle.swift
//  starship-shopper
//
//  Created by Charlie Quinn on 1/6/20.
//  Copyright © 2020 Charlie Quinn's Personal Projects. All rights reserved.
//

import Foundation

struct Vehicle: Decodable {
    let name: String
    let cargo_capacity: String
    let consumables: String
    let cost_in_credits: String
    let crew: String
    let length: String
    let manufacturer: String
    let max_atmosphering_speed: String
    let model: String
    let passengers: String
    let vehicle_class: String
}

extension Vehicle: SearchResult {
    func Title() -> String {
        return self.name
    }
    
    func Type() -> String {
        return "Vehicle"
    }
}

struct VehicleResponse: Decodable {
    let results: [Vehicle]
    let count: Int
    let next: String?
    let previous: String?
}
