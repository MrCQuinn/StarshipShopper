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
    
    private var currentPage = 1
    private var currentEndpoint = 0
    private var endpoints: [Endpoint]
    private var endpointCounts: [Endpoint:Int]
    
    private var total = 0
    
    private var isFetchInProgress = false
    
    let client = StarWarsClient()
    
    init(delegate:FetcherDelegate, endpoints: [Endpoint]) {
        self.delegate = delegate
        self.endpoints = endpoints
        self.endpointCounts = [Endpoint:Int]()
        for endpoint in endpoints {
            self.endpointCounts[endpoint] = 0
        }
    }
    
    func searchResult(at index: Int) -> SearchResult {
           return searchResults[index]
    }
    
    var currentCount: Int {
        return searchResults.count
    }
    
    var totalCount: Int {
        return self.total
    }
    
    func fetchSearchResults(query: String) {
        guard !isFetchInProgress else {
            return
        }
        
        isFetchInProgress = true
        
        client.fetchSearchResults(endpoint: self.endpoints[currentEndpoint], query: query, page: currentPage) { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                  self.isFetchInProgress = false
                  self.delegate?.onFetchFailed(with: error.reason)
                }
            case .success(let resp):
                guard let response = resp as? SearchResponse else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.currentPage += 1
                    self.isFetchInProgress = false
                        
                    // if we have all the results from one endpoint move on to the next
                    let currentEndpoint = self.endpoints[self.currentEndpoint]
                    if let count = self.endpointCounts[currentEndpoint] {
                        if count == 0 {
                            self.total += response.total
                        }
                        self.endpointCounts[currentEndpoint] = count + response.searchResults.count
                        if self.endpointCounts[currentEndpoint]! >= response.total {
                            self.currentPage = 0
                            self.currentEndpoint += 1
                        }
                    }
                    
                    self.searchResults.append(contentsOf: response.searchResults)

                    if self.currentPage > 2 {
                         let indexPathsToReload = self.calculateIndexPathsToReload(from: response.searchResults)
                         self.delegate?.onFetchCompleted(with: indexPathsToReload)
                    } else {
                         self.delegate?.onFetchCompleted(with: .none)
                    }
                 }
            }
        }
    }
    
    private func calculateIndexPathsToReload(from newResults: [SearchResult]) -> [IndexPath] {
       let startIndex = searchResults.count - newResults.count
       let endIndex = startIndex + newResults.count
       return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
