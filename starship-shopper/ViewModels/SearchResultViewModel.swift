//
//  SearchResultViewModel.swift
//  starship-shopper
//
//  Created by Charlie Quinn on 1/5/20.
//  Copyright © 2020 Charlie Quinn's Personal Projects. All rights reserved.
//

import UIKit

final class SearchResultViewModel {
    private weak var delegate: FetcherDelegate?
    
    private var searchResults: [SearchResult] = []

    private var endpoints: [Endpoint]
    
    private var isFetchInProgress = false
    
    let client = StarWarsClient()
    
    init(delegate:FetcherDelegate, endpoints: [Endpoint]) {
        self.delegate = delegate
        self.endpoints = endpoints
    }
    
    func searchResult(at index: Int) -> SearchResult {
           return searchResults[index]
    }
    
    var totalCount: Int {
        return self.searchResults.count
    }
    
    func fetchSearchResults(query: String) {
        guard !isFetchInProgress else {
            return
        }
        
        isFetchInProgress = true
        
        client.fetchSearchResults(endpoints: self.endpoints, query: query) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                  self.isFetchInProgress = false
                  self.delegate?.onFetchFailed(with: error.reason)
                }
            case .success(let resp):
                guard let results = resp as? [SearchResult] else {
                    return
                }
                DispatchQueue.main.async {
                    self.searchResults = results
                    self.isFetchInProgress = false
                    self.delegate?.onFetchCompleted(with: .none)
                }
            }
        }
            
            
    }

}
