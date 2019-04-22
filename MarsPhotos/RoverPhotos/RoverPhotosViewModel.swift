//
//  RoverPhotosViewModel.swift
//  MarsPhotos
//
//  Created by Евгений Нименко on 4/19/19.
//  Copyright © 2019 Евгений Нименко. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

class RoverPhotosViewModel {
    
    private let disposeBag = DisposeBag()
    private var apiProvider: MoyaProvider<RoverPhotosTarget>
    private let router: RoverPhotosRouter.Routes
    
    init(router: RoverPhotosRouter.Routes, rover: Rover) {
        self.router = router
        self.apiProvider = MoyaProvider<RoverPhotosTarget>(plugins: [NetworkLoggerPlugin(verbose: true)])
        self.rover = rover
    }
    
    private let _photos = BehaviorRelay<[RoverPhoto]>(value: [])
    private let _isFetching = BehaviorRelay<Bool>(value: false)
    private let _error = BehaviorRelay<String?>(value: nil)
    private let _insertions = BehaviorRelay<[Int]>(value: [])
    
    private let rover: Rover
    private var cameraKey: String?
    private var earthDate: String?
    private let limitPerPage = 25
    private var page = 1
    private var hasMore = true
    
    var isFetching: Driver<Bool> {
        return _isFetching.asDriver()
    }
    
    var photos: Driver<[RoverPhoto]> {
        return _photos.asDriver()
    }
    
    var error: Driver<String?> {
        return _error.asDriver()
    }
    
    var hasError: Bool {
        return _error.value != nil
    }
    
    var numberOfPhotos: Int {
        return _photos.value.count
    }
    
    var insertions: Driver<[Int]> {
        return _insertions.asDriver()
    }
    
    var roverCameras: [RoverCamera] {
        return rover.cameras
    }
    
    func photo(at index: Int) -> RoverPhoto? {
        guard index < _photos.value.count else {
            return nil
        }
        return _photos.value[index]
    }
    
    func loadMorePhotos() {
        if hasMore {
            self.page += 1
            fetchPhotos(shouldResetDataSource: false)
        }
    }
    
    func setupCameraDriver(_ camera: Driver<String?>) {
        camera.drive(onNext: { [weak self] value in
            if let value = value {
                self?.cameraKey = value.isEmpty ? nil : value
                self?.fetchPhotos(shouldResetDataSource: true)
            }
            
        }).disposed(by: disposeBag)
    }
    
    func setupEarthDateDriver(_ earthDate: Driver<String?>) {
        earthDate.drive(onNext: { [weak self] value in
            if let value = value {
                self?.earthDate = value.isEmpty ? nil : value
                self?.fetchPhotos(shouldResetDataSource: true)
            }
        }).disposed(by: disposeBag)
    }
    
    private func getRequestData() -> RoverPhotosRequestData {
        return RoverPhotosRequestData.init(
            roverName: self.rover.name,
            cameraKey: self.cameraKey,
            earthDate: self.earthDate,
            page: self.page)
    }

    private func fetchPhotos(shouldResetDataSource: Bool) {
        guard !_isFetching.value else { return }
        
        if shouldResetDataSource {
            self._photos.accept([])
            self.page = 1
            self.hasMore = true
        }
        
        self._isFetching.accept(true)
        
        apiProvider.rx
            .request(.getPhotos(getRequestData()))
            .debug()
            .subscribe() { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    do {
                        let photosResponse = try JSONDecoder().decode(PhotosResponse.self, from: response.data)
                        self.addPhotos(photosResponse.photos)
                    } catch let decodingError {
                        self._error.accept(decodingError.localizedDescription)
                    }
                case .error(let error):
                    self._error.accept(error.localizedDescription)
                }
                
                self._isFetching.accept(false)
            }.disposed(by: disposeBag)
        
    }
    
    private func addPhotos(_ photos: [RoverPhoto]) {
        let insertions = self.getInsertionsArray(from: self.numberOfPhotos, incomingArrayCount: photos.count)
        
        let newPhotosArray = self._photos.value + photos
        
        self._photos.accept(newPhotosArray)
        
        self._insertions.accept(insertions)
        
        if photos.count < self.limitPerPage {
            self.hasMore = false
        }
    }
    
    private func getInsertionsArray(from currentCapacity: Int, incomingArrayCount: Int) -> [Int] {
        guard incomingArrayCount > 0 else { return [] }
        
        var insertions = [currentCapacity]
        
        for index in 1..<incomingArrayCount {
            insertions.append(currentCapacity + index)
        }
        
        return insertions
    }
    
    func openPhotoEvent(image: UIImage?) {
        self.router.openPhotoViewer(image: image)
    }
    
}
