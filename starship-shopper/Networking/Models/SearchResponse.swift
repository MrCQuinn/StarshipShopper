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
    
    init(starshipResponse: StarshipResponse) {
        self.total = starshipResponse.count
        searchResults = [SearchResult]()
        for starship in starshipResponse.starships {
            searchResults.append(starship)
        }
    }
    
    init(planetResponse: PlanetResponse) {
        self.total = planetResponse.count
        searchResults = [SearchResult]()
        for planet in planetResponse.results {
            searchResults.append(planet)
        }
    }
}
