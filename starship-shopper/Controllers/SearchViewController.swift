//
//  SearchViewController.swift
//  starship-shopper
//
//  Created by Charlie Quinn on 1/5/20.
//  Copyright © 2020 Charlie Quinn's Personal Projects. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    private enum CellIdentifiers {
        static let searchResult = "SearchResult"
    }
    
    private enum StoryboardIdentifiers {
        static let starshipDetail = "StarshipDetail"
        static let planetDetail = "PlanetDetail"
        static let vehicleDetail = "VehicleDetail"
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    private var viewModel: SearchResultViewModel!
    
    private var query: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        
        tableView.isHidden = true
        tableView.dataSource = self
        tableView.delegate = self
        
        indicatorView.hidesWhenStopped = true
        
        viewModel = SearchResultViewModel(delegate: self, endpoints: [Endpoint.starships, Endpoint.planets, Endpoint.vehicles])
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.query = searchText
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.onSearchStart()
        if let query = self.query {
            viewModel.fetchSearchResults(query: query)
        }
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return viewModel.totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.searchResult, for: indexPath) as! SearchResultTableViewCell
        cell.configure(with: viewModel.searchResult(at: indexPath.row))
        return cell
    }
       
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        var vc: UIViewController?
        switch viewModel.searchResult(at: indexPath.row) {
        case let starship as Starship:
            if let starshipViewController = storyBoard.instantiateViewController(withIdentifier: StoryboardIdentifiers.starshipDetail) as? StarshipDetailsViewController {
                starshipViewController.starship = starship
                vc = starshipViewController
            }
        case let planet as Planet:
            if let planetViewController = storyBoard.instantiateViewController(withIdentifier: StoryboardIdentifiers.planetDetail) as? PlanetDetailViewController {
                planetViewController.planet = planet
                vc = planetViewController
            }
        case let vehicle as Vehicle:
            if let vehicleViewController = storyBoard.instantiateViewController(withIdentifier: StoryboardIdentifiers.vehicleDetail) as? VehicleDetailViewController {
                vehicleViewController.vehicle = vehicle
                vc = vehicleViewController
            }
        default:
            return
        }
        if let viewController = vc {
            self.present(viewController, animated: true, completion: nil)
        }
    }
}

extension SearchViewController: FetcherDelegate {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        indicatorView.stopAnimating()
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    func onFetchFailed(with reason: String) {
        indicatorView.stopAnimating()
        
        let title = "Warning"
        let action = UIAlertAction(title: "OK", style: .default)
        displayAlert(with: title, message:reason, actions: [action])
    }
}

private extension SearchViewController {
    func onSearchStart() {
        indicatorView.startAnimating()
        tableView.isHidden = true
    }
}

private extension SearchViewController {
    func displayAlert(with title: String, message: String, actions: [UIAlertAction]? = nil) {
      guard presentedViewController == nil else {
        return
      }
      
      let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
      actions?.forEach { action in
        alertController.addAction(action)
      }
      present(alertController, animated: true)
    }
}
