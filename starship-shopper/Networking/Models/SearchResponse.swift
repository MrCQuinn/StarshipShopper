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
}

class StarshipSearchResponse: SearchResponse {
    init(starshipResponse: StarshipResponse) {
        super.init(total: starshipResponse.count, next: starshipResponse.next)
        for starship in starshipResponse.starships {
            self.searchResults.append(starship)
        }
    }
}

class PlanetSearchResponse: SearchResponse {
    init(planetResponse: PlanetResponse, next: String? ) {
        super.init(total: planetResponse.count, next: planetResponse.next)
        for planet in planetResponse.results {
            searchResults.append(planet)
        }
    }
}
