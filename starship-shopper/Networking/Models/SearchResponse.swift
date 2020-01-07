//
//  SearchResponse.swift
//  starship-shopper
//
//  Created by Charlie Quinn on 1/5/20.
//  Copyright © 2020 Charlie Quinn's Personal Projects. All rights reserved.
//

import Foundation

class SearchResponse {
    var total: Int
    var searchResults: [SearchResult]
    var next: String?
    
    init(total: Int, next: String?) {
        self.total = total
        self.next = next
        self.searchResults = [SearchResult]()
    }
    
    init(total: Int, next: String?, results: [SearchResult]) {
        self.total = total
        self.next = next
        self.searchResults = results
    }
}

class StarshipSearchResponse: SearchResponse {
    init(starshipResponse: StarshipResponse) {
        super.init(total: starshipResponse.count, next: starshipResponse.next, results: starshipResponse.results)
    }
}

class PlanetSearchResponse: SearchResponse {
    init(planetResponse: PlanetResponse) {
        super.init(total: planetResponse.count, next: planetResponse.next, results: planetResponse.results)
    }
}

class VehicleSearchResponse: SearchResponse {
    init(vehicleResponse: VehicleResponse) {
        super.init(total: vehicleResponse.count, next: vehicleResponse.next, results: vehicleResponse.results)
    }
}
