//
//  SearchResultTableViewCell.swift
//  starship-shopper
//
//  Created by Charlie Quinn on 1/5/20.
//  Copyright © 2020 Charlie Quinn's Personal Projects. All rights reserved.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(with: .none)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        indicatorView.hidesWhenStopped = true
    }
    
    func configure(with searchResult: SearchResult?) {
        guard let searchResult = searchResult else {
            setBlank()
            indicatorView.startAnimating()
            return
        }
        
        titleLabel?.text = searchResult.Title()
        typeLabel?.text = searchResult.Type()
        indicatorView.stopAnimating()
    }
    
    func setBlank() {
        titleLabel?.text = ""
        typeLabel?.text = ""
    }
}
