//
//  Rover.swift
//  MarsPhotos
//
//  Created by Евгений Нименко on 4/19/19.
//  Copyright © 2019 Евгений Нименко. All rights reserved.
//

import Foundation

enum RoverCamera: String  {
    case FHAZ = "Front Hazard Avoidance Camera"
    case RHAZ = "Rear Hazard Avoidance Camera"
    case MAST = "Mast Camera"
    case CHEMCAM = "Chemistry and Camera Complex"
    case MAHLI = "Mars Hand Lens Imager"
    case MARDI = "Mars Descent Imager"
    case NAVCAM = "Navigation Camera"
    case PANCAM = "Panoramic Camera"
    case MINITES = "Miniature Thermal Emission Spectrometer (Mini-TES)"
}

struct Rover {
    let name: String
    let cameras: [RoverCamera]
}

struct RoversBuilder {
    static func build() -> [Rover] {
        return [
            Rover(name: "Curiosity", cameras: [.FHAZ, .RHAZ, .MAST, .CHEMCAM, .MAHLI, .MARDI, .NAVCAM]),
            Rover(name: "Opportunity", cameras: [.FHAZ, .RHAZ, .NAVCAM, .PANCAM, .MINITES]),
            Rover(name: "Spirit", cameras: [.FHAZ, .RHAZ, .NAVCAM, .PANCAM, .MINITES])
        ]
    }
}
