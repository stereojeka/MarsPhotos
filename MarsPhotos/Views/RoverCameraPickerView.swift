//
//  RoverCameraPickerView.swift
//  MarsPhotos
//
//  Created by Евгений Нименко on 4/19/19.
//  Copyright © 2019 Евгений Нименко. All rights reserved.
//

import UIKit

class RoverCameraPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {

    let pickerOptions: [RoverCamera]
    
    var didSelectCamera: ((RoverCamera) -> ())?
    
    init(with availableCameras: [RoverCamera]) {
        pickerOptions = availableCameras
        super.init(frame: .zero)
        super.dataSource = self
        super.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerOptions[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerOptions.indices.contains(row) {
            didSelectCamera?(pickerOptions[row])
        }
    }

}
