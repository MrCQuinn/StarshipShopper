//
//  FetchOnScrollDelegate.swift
//  starship-shopper
//
//  Created by Charlie Quinn on 1/5/20.
//  Copyright © 2020 Charlie Quinn's Personal Projects. All rights reserved.
//

import Foundation

protocol FetcherDelegate: class {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
}
