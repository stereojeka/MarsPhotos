//
//  RoverPhotosTarget.swift
//  MarsPhotos
//
//  Created by Евгений Нименко on 4/19/19.
//  Copyright © 2019 Евгений Нименко. All rights reserved.
//

import Moya

enum RoverPhotosTarget {
    case getPhotos(_ requestData: RoverPhotosRequestData)
}

extension RoverPhotosTarget: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.nasa.gov/mars-photos/api/v1")!
    }
    
    var path: String {
        switch self {
        case .getPhotos(let requestData):
            return "/rovers/" + requestData.roverName.lowercased() + "/photos"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var parameters: [String: Any] {
        switch self {
        case .getPhotos(let requestData):
            
            var resultParameters: [String: Any] = [
                "page": requestData.page,
                "api_key": "Fp1lvHzDrBqDYTdJMx0zwBV9ZT0HLQCfosXtezgk"
            ]
            
            if let cameraKey = requestData.cameraKey {
                resultParameters["camera"] = cameraKey.lowercased()
            }
            
            if let earthDate = requestData.earthDate {
                resultParameters["earth_date"] = earthDate
            } else {
                resultParameters["sol"] = 1000
            }
            
            return resultParameters
        }
    }
    
    var task: Task {
        switch self {
        case .getPhotos(_):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
}
