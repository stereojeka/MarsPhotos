//
//  PhotoViewRoute.swift
//  MarsPhotos
//
//  Created by Евгений Нименко on 4/19/19.
//  Copyright © 2019 Евгений Нименко. All rights reserved.
//

import UIKit

protocol PhotoViewerRoute {
    var openPhotoTransition: Transition { get }
    func openPhotoViewer(image: UIImage?)
}

extension PhotoViewerRoute where Self: RouterProtocol {
    
    var openPhotoTransition: Transition {
        return ModalTransition(animator: nil, isAnimated: true, modalTransitionStyle: .crossDissolve, modalPresentationStyle: .overFullScreen)
    }
    
    func openPhotoViewer(image: UIImage?) {
        let router = PhotoViewerRouter()
        let transition = openPhotoTransition
        router.openTransition = transition
        
        let photoViewerController = PhotoViewerController.createFromStoryboard()
        photoViewerController.image = image
        photoViewerController.router = router
        
        router.viewController = photoViewerController
        
        open(photoViewerController, transition: transition)
    }
}
