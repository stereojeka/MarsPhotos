//
//  RoverPhoto+Response.swift
//  MarsPhotos
//
//  Created by Евгений Нименко on 4/19/19.
//  Copyright © 2019 Евгений Нименко. All rights reserved.
//

import Foundation

struct RoverPhoto: Codable {
    let photoUrl: String
    let createdAt: String
    
    private enum CodingKeys: String, CodingKey {
        case photoUrl = "img_src"
        case createdAt = "earth_date"
    }
}

struct PhotosResponse: Codable {
    let photos: [RoverPhoto]
}
