//
//  StarshipDetailViewController.swift
//  starship-shopper
//
//  Created by Charlie Quinn on 12/28/19.
//  Copyright © 2019 Charlie Quinn's Personal Projects. All rights reserved.
//

import UIKit

class StarshipDetailsViewController: UIViewController {
    
    var starship: Starship?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let starship = self.starship {
            nameLabel.text? = starship.name
            if let cost = starship.cost {
                priceLabel.text? = "₹"+String(cost)
            }else {
                priceLabel.text? = "Unknown"
            }
        }
    }
}
