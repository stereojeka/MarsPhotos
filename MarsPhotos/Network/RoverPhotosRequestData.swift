//
//  RoverPhotosRequestData.swift
//  MarsPhotos
//
//  Created by Евгений Нименко on 4/19/19.
//  Copyright © 2019 Евгений Нименко. All rights reserved.
//

import Foundation

struct RoverPhotosRequestData {
    let roverName: String
    let cameraKey: String?
    let earthDate: String?
    var page: Int
}
