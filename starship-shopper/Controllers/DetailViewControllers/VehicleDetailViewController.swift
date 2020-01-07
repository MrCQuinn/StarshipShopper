//
//  VehicleDetailViewController.swift
//  starship-shopper
//
//  Created by Charlie Quinn on 1/6/20.
//  Copyright © 2020 Charlie Quinn's Personal Projects. All rights reserved.
//

import UIKit

class VehicleDetailViewController: UIViewController {
    
    var vehicle: Vehicle?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var vehicleClassLabel: UILabel!
    @IBOutlet weak var manufacturerLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var crewLabel: UILabel!
    @IBOutlet weak var passengersLabel: UILabel!
    @IBOutlet weak var maxAtmosphericSpeedLabel: UILabel!
    @IBOutlet weak var cargoCapacityLabel: UILabel!
    @IBOutlet weak var consumablesLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let vehicle = self.vehicle {
            nameLabel.text? = vehicle.name
            modelLabel.text? = vehicle.model
            vehicleClassLabel.text? = vehicle.vehicle_class
            manufacturerLabel.text? = vehicle.manufacturer
            lengthLabel.text? = vehicle.length
            costLabel.text? = vehicle.cost_in_credits
            crewLabel.text? = vehicle.crew
            passengersLabel.text? = vehicle.passengers
            maxAtmosphericSpeedLabel.text? = vehicle.max_atmosphering_speed
            cargoCapacityLabel.text? = vehicle.cargo_capacity
            consumablesLabel.text? = vehicle.consumables
        }
    }
    


}
