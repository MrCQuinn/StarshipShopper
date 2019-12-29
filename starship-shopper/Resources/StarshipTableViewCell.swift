//
//  StarshipTableViewCell.swift
//  starship-shopper
//
//  Created by Charlie Quinn on 12/28/19.
//  Copyright © 2019 Charlie Quinn's Personal Projects. All rights reserved.
//

import UIKit

class StarshipTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        configure(with: .none)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        indicatorView.hidesWhenStopped = true
    }
    
    func configure(with starship: Starship?) {
        if let starship = starship {
            nameLabel?.text = starship.name
            indicatorView.stopAnimating()
        }else {
            nameLabel?.text = ""
            indicatorView.startAnimating()
        }
    }
}