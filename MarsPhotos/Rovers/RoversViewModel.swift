//
//  RoversViewModel.swift
//  MarsPhotos
//
//  Created by Евгений Нименко on 4/19/19.
//  Copyright © 2019 Евгений Нименко. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol RoversDataSource {
    var dataSource: Observable<[Rover]> { get }
}

class RoversViewModel: RoversDataSource {
    
    private let router: RoversRouter.Routes
    
    var dataSource: Observable<[Rover]>
    
    init(router: RoversRouter.Routes) {
        self.router = router
        self.dataSource = Observable.of(RoversBuilder.build())
    }
    
    func didSelectRover(_ rover: Rover) {
        router.openRoverPhotosModule(for: rover)
    }
    
}
