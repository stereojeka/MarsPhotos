//
//  RoverPhotosModule.swift
//  MarsPhotos
//
//  Created by Евгений Нименко on 4/19/19.
//  Copyright © 2019 Евгений Нименко. All rights reserved.
//

import Foundation

final class RoverPhotosModule {
    
    let router: RoverPhotosRouter
    let viewController: RoverPhotosViewController
    
    private let viewModel: RoverPhotosViewModel
    
    init(rover: Rover) {
        let router = RoverPhotosRouter()
        let viewModel = RoverPhotosViewModel(router: router, rover: rover)
        let viewController = RoverPhotosViewController.createFromStoryboard()
        viewController.viewModel = viewModel
        router.viewController = viewController
        
        self.router = router
        self.viewModel = viewModel
        self.viewController = viewController
    }
    
}
