//
//  StarshipListViewController.swift
//  starship-shopper
//
//  Created by Charlie Quinn on 12/28/19.
//  Copyright © 2019 Charlie Quinn's Personal Projects. All rights reserved.
//

import UIKit

class StarshipListViewController: UIViewController {
    private enum CellIdentifiers {
        static let starship = "StarshipCell"
    }
    
    private enum SegueIdentifiers {
        static let starshipDetail = "StarshipDetailSegue"
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    private var viewModel: StarshipViewModel!
    private var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicatorView.startAnimating()
        indicatorView.hidesWhenStopped = true
        
        tableView.isHidden = true
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.delegate = self
        
        viewModel = StarshipViewModel(endpoint: "starships", delegate: self)
        viewModel.fetchStarships()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifiers.starshipDetail {
            let secondVc = segue.destination as! StarshipDetailsViewController
            let indexPath = sender as! IndexPath
            
            secondVc.starship = viewModel.starship(at: indexPath.row)
        }
    }
}

extension StarshipListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.starship, for: indexPath) as! StarshipTableViewCell
        
        if isLoadingCell(for: indexPath) {
            cell.configure(with: .none)
        }else {
            cell.configure(with: viewModel.starship(at: indexPath.row))
        }
        return cell
    }
}

extension StarshipListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.fetchStarships()
        }
    }
}

extension StarshipListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: SegueIdentifiers.starshipDetail, sender: indexPath)
    }
}

extension StarshipListViewController: StarshipViewModelDelegate {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            indicatorView.stopAnimating()
            tableView.isHidden = false
            tableView.reloadData()
            return
        }
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }
    
    func onFetchFailed(with reason: String) {
        indicatorView.stopAnimating()
        
        let title = "Warning"
        let action = UIAlertAction(title: "OK", style: .default)
        displayAlert(with: title, message:reason, actions: [action])
    }
}


private extension StarshipListViewController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.currentCount
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}

private extension StarshipListViewController {
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
