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
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var manufacturersLabel: NSLayoutConstraint!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var maxAtmosphericSpeedLabel: UILabel!
    @IBOutlet weak var hyperdriveRatingLabel: UILabel!
    @IBOutlet weak var mgltphLabel: UILabel!
    @IBOutlet weak var crewSizeLabel: UILabel!
    @IBOutlet weak var passengerCapacityLabel: UILabel!
    @IBOutlet weak var cargoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let starship = self.starship {
            nameLabel.text? = starship.name
            priceLabel.text? = starship.formatCostString()
            modelLabel.text? = starship.model
            classLabel.text? = starship.starshipClass
//            manufacturersLabel.text? = starship.manufacturersstarship.manufacturers.joined(separator: ", ")
            lengthLabel.text? = starship.formatLengthString()
            maxAtmosphericSpeedLabel.text? = starship.formatMaxAtmosphericSpeedLabel()
            hyperdriveRatingLabel.text? = starship.formatHyperdriveRating()
            mgltphLabel.text? = starship.formatMGL()
            crewSizeLabel.text? = starship.formatCrewSize()
            passengerCapacityLabel.text? = starship.formatPassengerCapacity()
            cargoLabel.text? = starship.formatCargoCapacity()
        }
    }
}
