//
//  Starship.swift
//  starship-shopper
//
//  Created by Charlie Quinn on 12/28/19.
//  Copyright © 2019 Charlie Quinn's Personal Projects. All rights reserved.
//

import Foundation

struct Starship: Decodable {
    let name: String
//    let model: String
//    let manufacturer: String
    let cost: Int?
//    let length: Double
//    let maxSpeed: Int
//    let crewSize: Int
//    let passengerCapacity: Int
//    let cargoCapacity: Int
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case model = "model"
        case manufacturer = "manufacturer"
        case cost = "cost_in_credits"
        case length = "length"
        case maxSpeed = "max_atmosphering_speed"
        case crewSize = "crew"
        case passengerCapacity = "passengers"
        case cargoCapacity = "cargo_capacity"
    }
    
    init(name: String, model: String, manufacturer: String, cost: Int, length: Double, maxSpeed: Int, crewSize: Int,
         passengerCapacity: Int, cargoCapacity: Int) {
         self.name = name
//         self.model = model
//         self.manufacturer = manufacturer
         self.cost = cost
//         self.length = length
//         self.maxSpeed = maxSpeed
//         self.crewSize = crewSize
//         self.passengerCapacity = passengerCapacity
//         self.cargoCapacity = cargoCapacity
    }
    
    // for testing
    init(name: String, cost: Int?)  {
        self.name = name
        self.cost = cost
    }
    
    init(from decoder: Decoder) throws {
        let container               = try decoder.container(keyedBy: CodingKeys.self)
        let name                    = try container.decode(String.self, forKey: .name)
//        let model                   = try container.decode(String.self, forKey: .model)
//        let manufacturer            = try container.decode(String.self, forKey: .manufacturer)
        let costString                    = try container.decode(String.self, forKey: .cost)
        
        let cost = Int(costString)
//        let length                  = try container.decode(Double.self, forKey: .length)
//        let maxSpeed                = try container.decode(Int.self, forKey: .maxSpeed)
//        let crewSize                = try container.decode(Int.self, forKey: .crewSize)
//        let passengerCapacity       = try container.decode(Int.self, forKey: .passengerCapacity)
//        let cargoCapacity           = try container.decode(Int.self, forKey: .cargoCapacity)
//        self.init(name: name, model: model, manufacturer: manufacturer, cost: cost, length: length, maxSpeed: maxSpeed, crewSize: crewSize,
//        passengerCapacity: passengerCapacity, cargoCapacity: cargoCapacity)
        self.init(name: name, cost: cost)
    }
    
    func formatCostString() -> String {
        if let cost = self.cost {
            return "₹"+String(cost)
        }
        
        return "Cost Unknown"
    }
    
    enum Sortables {
           static let cost = "Cost"
    }
}

/*
 {
     "name": "Millennium Falcon",
     "model": "YT-1300 light freighter",
     "manufacturer": "Corellian Engineering Corporation",
     "cost_in_credits": "100000",
     "length": "34.37",
     "max_atmosphering_speed": "1050",
     "crew": "4",
     "passengers": "6",
     "cargo_capacity": "100000",
     "consumables": "2 months",
     "hyperdrive_rating": "0.5",
     "MGLT": "75",
     "starship_class": "Light freighter",
     "pilots": [
         "https://swapi.co/api/people/13/",
         "https://swapi.co/api/people/14/",
         "https://swapi.co/api/people/25/",
         "https://swapi.co/api/people/31/"
     ],
     "films": [
         "https://swapi.co/api/films/2/",
         "https://swapi.co/api/films/7/",
         "https://swapi.co/api/films/3/",
         "https://swapi.co/api/films/1/"
     ],
     "created": "2014-12-10T16:59:45.094000Z",
     "edited": "2014-12-22T17:35:44.464156Z",
     "url": "https://swapi.co/api/starships/10/"
 }
 */
