//
//  RoverPhotosViewController.swift
//  MarsPhotos
//
//  Created by Евгений Нименко on 4/19/19.
//  Copyright © 2019 Евгений Нименко. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RoverPhotosViewController: UIViewController, StoryboardInitializable {
    
    @IBOutlet weak var cameraInput: UITextField!
    @IBOutlet weak var dateInput: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var datePicker: UIDatePicker?
    private var cameraPicker: RoverCameraPickerView?
    
    var viewModel: RoverPhotosViewModel?
    
    var rover: Rover?
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupDateInput()
        setupCameraInput()
        hideKeyboardWhenTappedAround()
        setupTableView()
        configureModel()
    }
    
    private func configureModel() {
        viewModel?.setupCameraDriver(cameraInput.rx.text.asDriver())
        viewModel?.setupEarthDateDriver(dateInput.rx.text.asDriver())
        
        viewModel?.photos.drive(onNext: { [weak self] (photos) in
            if photos.isEmpty {
                self?.tableView.reloadData()
            }
        }).disposed(by: disposeBag)
        
        viewModel?.insertions.drive(onNext: { [weak self] insertions in
            if let firstIndex = insertions.first, firstIndex == 0 {
                self?.tableView?.reloadData()
            } else {
                self?.tableView.beginUpdates()
                
                self?.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                
                self?.tableView.endUpdates()
            }
        }).disposed(by: disposeBag)
        
        viewModel?.isFetching.drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        viewModel?.error.drive(onNext: {[weak self] (error) in
            guard let self = self, let viewModel = self.viewModel else { return }
            self.infoLabel.isHidden = !viewModel.hasError
            self.infoLabel.text = error
        }).disposed(by: disposeBag)
    }
    
    private func setupDateInput() {
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.maximumDate = Date()
        datePicker?.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        
        dateInput.inputView = datePicker
        dateInput.delegate = self
    }
    
    private func setupTableView() {
        tableView.rowHeight = UIScreen.main.bounds.size.width
        tableView.register(RoverPhotoTableViewCell.self, forCellReuseIdentifier: "RoverPhotoTableViewCell")
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupCameraInput() {
        guard let viewModel = viewModel else { return }
        cameraPicker = RoverCameraPickerView(with: viewModel.roverCameras)
        cameraPicker?.didSelectCamera = { [weak self] camera in
            self?.cameraInput.text = "\(camera)"
            self?.view.endEditing(true)
        }
        cameraInput.inputView = cameraPicker
        cameraInput.delegate = self
    }
    
    @objc private func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let formattedDate = dateFormatter.string(from: datePicker.date)
        dateInput.text = formattedDate
        
        view.endEditing(true)
    }

}

extension RoverPhotosViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}

extension RoverPhotosViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfPhotos ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoverPhotoTableViewCell", for: indexPath) as! RoverPhotoTableViewCell
        
        if let photo = viewModel?.photo(at: indexPath.row) {
            cell.roverPhoto = photo
        }
        
        cell.didTapOnImage = { [weak self] image in
            self?.viewModel?.openPhotoEvent(image: image)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let numberOfPhotos = viewModel?.numberOfPhotos, indexPath.row == numberOfPhotos - 1 {
            viewModel?.loadMorePhotos()
        }
    }
}
