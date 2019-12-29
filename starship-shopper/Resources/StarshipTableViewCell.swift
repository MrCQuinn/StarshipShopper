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
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var creditsIcon: UIImageView!
    
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
            costLabel?.text = starship.formatCostString()
            
            indicatorView.stopAnimating()
        }else {
            setBlank()
            indicatorView.startAnimating()
        }
    }
    
    func setBlank() {
        nameLabel?.text = ""
        costLabel?.text = ""
        creditsIcon?.isHidden = true
    }
}
