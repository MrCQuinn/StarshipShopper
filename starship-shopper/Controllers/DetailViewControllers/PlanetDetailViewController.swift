//
//  PlanetDetailViewController.swift
//  starship-shopper
//
//  Created by Charlie Quinn on 1/6/20.
//  Copyright © 2020 Charlie Quinn's Personal Projects. All rights reserved.
//

import UIKit

class PlanetDetailViewController: UIViewController {
    
    var planet: Planet?

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var diameterLabel: UILabel!
    @IBOutlet weak var rotationPeriodLabel: UILabel!
    @IBOutlet weak var orbitalPeriodLabel: UILabel!
    @IBOutlet weak var gravityLabel: UILabel!
    @IBOutlet weak var populationLabel: UILabel!
    @IBOutlet weak var climateLabel: UILabel!
    @IBOutlet weak var terrainLabel: UILabel!
    @IBOutlet weak var surfaceWaterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let planet = self.planet {
            nameLabel.text? = planet.name
            diameterLabel.text? = planet.diameter
            rotationPeriodLabel.text? = planet.rotation_period
            orbitalPeriodLabel.text? = planet.orbital_period
            gravityLabel.text? = planet.gravity
            populationLabel.text? = planet.population
            climateLabel.text? = planet.climate
            terrainLabel.text? = planet.terrain
            surfaceWaterLabel.text? = planet.surface_water
        }
    }
    

}
