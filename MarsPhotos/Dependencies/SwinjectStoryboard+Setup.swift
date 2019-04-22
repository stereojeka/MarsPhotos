//
//  SwinjectStoryboard+Setup.swift
//  MarsPhotos
//
//  Created by Евгений Нименко on 4/19/19.
//  Copyright © 2019 Евгений Нименко. All rights reserved.
//

import Swinject
import SwinjectStoryboard
import SwinjectAutoregistration

extension SwinjectStoryboard {
    
    @objc class func setup() {
        defaultContainer.autoregister(RoversRouter.self, initializer: RoversRouter.init)
        
        defaultContainer.storyboardInitCompleted(RoversViewController.self) { resolver, controller in
            
            let router = resolver.resolve(RoversRouter.self)!
            router.viewController = controller
            
            let viewModel = RoversViewModel(router: router)
            
            controller.viewModel = viewModel
        }
    }
    
}
