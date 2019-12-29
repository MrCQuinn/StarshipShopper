//
//  StarshipViewModel.swift
//  starship-shopper
//
//  Created by Charlie Quinn on 12/28/19.
//  Copyright © 2019 Charlie Quinn's Personal Projects. All rights reserved.
//

import UIKit

protocol StarshipViewModelDelegate: class {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
}

final class StarshipViewModel {
    private weak var delegate: StarshipViewModelDelegate?
    
    private var starships: [Starship] = []
    private var currentPage  = 1
    private var total = 0
    private var isFetchInProgress = false
    
    let client = StarWarsClient()
    let endpoint: String
    
    init(endpoint: String, delegate: StarshipViewModelDelegate) {
        self.endpoint = endpoint
        self.delegate = delegate
    }
    
    var totalCount: Int {
        return total
    }
    
    var currentCount: Int {
       return starships.count
     }
     
     func starship(at index: Int) -> Starship {
       return starships[index]
     }
    
    func fetchStarships() {
      guard !isFetchInProgress else {
        return
      }
      
      isFetchInProgress = true
      
        client.fetchStarships(endpoint: self.endpoint, page: currentPage) { result in
        switch result {
        case .failure(let error):
          DispatchQueue.main.async {
            self.isFetchInProgress = false
            self.delegate?.onFetchFailed(with: error.reason)
          }
        case .success(let response):
          DispatchQueue.main.async {
            self.currentPage += 1
            self.isFetchInProgress = false
            self.total = response.count
            self.starships.append(contentsOf: response.starships)
 
            if self.currentPage > 2 {
              let indexPathsToReload = self.calculateIndexPathsToReload(from: response.starships)
              self.delegate?.onFetchCompleted(with: indexPathsToReload)
            } else {
              self.delegate?.onFetchCompleted(with: .none)
            }
          }
        }
      }
    }
    
    private func calculateIndexPathsToReload(from newStarships: [Starship]) -> [IndexPath] {
       let startIndex = starships.count - newStarships.count
       let endIndex = startIndex + newStarships.count
       return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
     }
}
