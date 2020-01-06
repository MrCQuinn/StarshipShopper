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
    private var fetchAll = false
    
    let client = StarWarsClient()
    
    init(delegate: StarshipViewModelDelegate) {
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
    
    func isFetched() -> Bool {
        return starships.count >= total
    }
    
    func fetchUntilCompletion() {
        self.fetchAll = true
        self.fetchStarships()
    }
    
    func fetchStarships() {
      guard !isFetchInProgress else {
        return
      }
      
      isFetchInProgress = true
      
        client.fetchStarships(page: currentPage) { result in
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
            
            if self.fetchAll && !self.isFetched() {
                self.fetchStarships()
            }
          }
        }
      }
    }
    
    func sortOn(sortOn: String, desc: Bool) {
        switch sortOn {
        case Starship.Sortables.cost:
            if desc {
                self.starships.sort(by: costSortDesc)
                return
            }
            self.starships.sort(by: costSortAsc)
        default:
            print("Sortable "+" is not implemented")
        }
    }
    
    func costSortDesc(this:Starship, that:Starship) -> Bool {
        guard let thisCost = this.cost else {
            return false
        }
        guard let thatCost = that.cost else {
            return true
        }
        
        return thisCost > thatCost
    }
    
    func costSortAsc(this:Starship, that:Starship) -> Bool {
        guard let thisCost = this.cost else {
           return false
        }
        guard let thatCost = that.cost else {
           return true
        }
        
        return thisCost < thatCost
    }
    
    private func calculateIndexPathsToReload(from newStarships: [Starship]) -> [IndexPath] {
       let startIndex = starships.count - newStarships.count
       let endIndex = startIndex + newStarships.count
       return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
