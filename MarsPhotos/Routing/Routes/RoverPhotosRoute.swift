//
//  RoverPhotosRoute.swift
//  MarsPhotos
//
//  Created by Евгений Нименко on 4/19/19.
//  Copyright © 2019 Евгений Нименко. All rights reserved.
//

import UIKit

protocol RoverPhotosRoute {
    var roverPhotosTransition: Transition { get }
    func openRoverPhotosModule(for rover: Rover)
}

extension RoverPhotosRoute where Self: RouterProtocol {
    
    var roverPhotosTransition: Transition {
        return PushTransition()
    }
    
    func openRoverPhotosModule(for rover: Rover) {
        let module = RoverPhotosModule(rover: rover)
        let transition = roverPhotosTransition
        
        module.router.openTransition = transition
        open(module.viewController, transition: transition)
    }
}

