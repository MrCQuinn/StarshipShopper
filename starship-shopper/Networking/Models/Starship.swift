//
//  Starship.swift
//  starship-shopper
//
//  Created by Charlie Quinn on 12/28/19.
//  Copyright © 2019 Charlie Quinn's Personal Projects. All rights reserved.
//

import Foundation

struct Starship: Decodable {
    //     The name of this starship. The common name, such as "Death Star"
            let name: String
        //     The model or official name of this starship. Such as "T-65 X-wing" or "DS-1 Orbital Battle Station".
            let model: String
    //    The class of this starship, such as "Starfighter" or "Deep Space Mobile Battlestation"
            let starshipClass: String
        //      The manufacturer of this starship. Comma separated if more than one.
            let manufacturers: [String]
        //     The cost of this starship new, in galactic credits.
            let cost: Int?
        //      The length of this starship in meters.
            let length: Double?
        //    The maximum speed of this starship in the atmosphere. "N/A" if this starship is incapable of atmospheric flight.
            let maxAtmosphericSpeed: Int?
        //    The class of this starships hyperdrive.
            let hyperdriveRating: Double?
        //    The Maximum number of Megalights this starship can travel in a standard hour. A "Megalight" is a standard unit of distance and has never been defined before within the Star Wars universe. This figure is only really useful for measuring the difference in speed of starships. We can assume it is similar to AU, the distance between our Sun (Sol) and Earth.
            let maxMGLTPH: Int?
        //  The number of personnel needed to run or pilot this starship.
            let crewSize: Int?
        //    The number of non-essential people this starship can transport.
            let passengerCapacity: Int?
        //    The maximum number of kilograms that this starship can transport.
            let cargoCapacity: Int?
        
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case model = "model"
        case starshipClass = "starship_class"
        case manufacturer = "manufacturer"
        case cost = "cost_in_credits"
        case length = "length"
        case crewSize = "crew"
        case passengerCapacity = "passengers"
        case maxAtmosphericSpeed = "max_atmosphering_speed"
        case hyperdriveRating = "hyperdrive_rating"
        case MGLT = "MGLT"
        case cargoCapacity = "cargo_capacity"
    }
    
    init(name: String, model: String, starshipClass: String, manufacturers: [String], cost: Int?, length: Double?, crewSize: Int?, passengerCapacity: Int?, maxAtmosphericSpeed: Int?, hyperdriveRating: Double?, maxMGLTPH: Int?,
         cargoCapacity: Int?) {
        self.name = name
        self.model = model
        self.starshipClass = starshipClass
        self.manufacturers = manufacturers
        self.cost = cost
        self.length = length
        self.crewSize = crewSize
        self.passengerCapacity = passengerCapacity
        self.maxAtmosphericSpeed = maxAtmosphericSpeed
        self.hyperdriveRating = hyperdriveRating
        self.maxMGLTPH = maxMGLTPH
        self.cargoCapacity = cargoCapacity
    }
    
    init(from decoder: Decoder) throws {
        let container                     = try decoder.container(keyedBy: CodingKeys.self)
        let name                          = try container.decode(String.self, forKey: .name)
        let model                         = try container.decode(String.self, forKey: .model)
        let starshipClass                 = try container.decode(String.self, forKey: .starshipClass)
        let manufacturerString            = try container.decode(String.self, forKey: .manufacturer)
        let costString                    = try container.decode(String.self, forKey: .cost)
        let lengthString                  = try container.decode(String.self, forKey: .length)
        let crewSizeString                = try container.decode(String.self, forKey: .crewSize)
        let passengerCapacityString       = try container.decode(String.self, forKey: .passengerCapacity)
        let maxAtmosphericSpeedString     = try container.decode(String.self, forKey: .maxAtmosphericSpeed)
        let hyperdriveRatingString        = try container.decode(String.self, forKey: .hyperdriveRating)
        let cargoCapacityString           = try container.decode(String.self, forKey: .cargoCapacity)
        let MGLTString                    = try container.decode(String.self, forKey: .MGLT)
        
        let manufacturers = manufacturerString.components(separatedBy: ", ")
        let cost = Int(costString)
        let length = Double(lengthString)
        let crewSize = Int(crewSizeString)
        let passengersCapacity = Int(passengerCapacityString)
        let maxAtmosphericSpeed = Int(maxAtmosphericSpeedString)
        let hyperdriveRating = Double(hyperdriveRatingString)
        let cargoCapacity = Int(cargoCapacityString)
        
        var maxMGLTPH: Int?
        for item in MGLTString.components(separatedBy: CharacterSet.decimalDigits.inverted) {
           if let number = Int(item) {
               maxMGLTPH = number
               break
           }
        }
        
        self.init(name: name, model: model, starshipClass: starshipClass, manufacturers: manufacturers, cost: cost, length: length,
        crewSize: crewSize, passengerCapacity: passengersCapacity,
        maxAtmosphericSpeed: maxAtmosphericSpeed, hyperdriveRating: hyperdriveRating, maxMGLTPH: maxMGLTPH, cargoCapacity: cargoCapacity)
    }
    
    func formatCostString() -> String {
        if let cost = self.cost {
            return "₹"+String(cost)
        }
        
        return "Cost Unknown"
    }
    
    func formatLengthString() -> String {
        guard let length = self.length else {
            return "Length Unknown"
        }
        return String(length)+"m"
    }
    
    func formatMaxAtmosphericSpeedLabel() -> String {
        guard let speed = self.maxAtmosphericSpeed else {
            return "N/A"
        }
        return String(speed)+" MPH"
    }
    
    func formatHyperdriveRating() -> String {
        guard let rating = self.hyperdriveRating else {
            return "Unavailable"
        }
        return String(rating)
    }
    
    func formatMGL() -> String {
        guard let mgl = self.maxMGLTPH else {
            return "Unknown"
        }
        return String(mgl)+" MGLT"
    }
    
    func formatCrewSize() -> String {
        guard let size = self.crewSize else {
            return "Unknown"
        }
        return String(size)
    }
    
    func formatPassengerCapacity() -> String {
        guard let capacity = self.passengerCapacity else {
           return "Unknown"
       }
        return String(capacity)
    }
    
    func formatCargoCapacity() -> String {
        guard let capacity = self.cargoCapacity else {
            return "Unknown"
        }
        return String(capacity)
    }
    
    enum Sortables {
           static let cost = "Cost"
    }
}

extension Starship: SearchResult {
    func Title() -> String {
        return self.name
    }
    
    func Type() -> String {
        return "Starship"
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
