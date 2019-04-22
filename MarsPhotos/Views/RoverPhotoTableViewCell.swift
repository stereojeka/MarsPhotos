//
//  RoverPhotoTableViewCell.swift
//  MarsPhotos
//
//  Created by Евгений Нименко on 4/19/19.
//  Copyright © 2019 Евгений Нименко. All rights reserved.
//

import UIKit
import Kingfisher

class RoverPhotoTableViewCell: UITableViewCell {
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8.0
        imageView.clipsToBounds = true
        imageView.kf.indicatorType = .activity
        return imageView
    }()
    
    var roverPhoto: RoverPhoto! {
        didSet {
            if let url = URL(string: roverPhoto.photoUrl) {
                photoImageView.kf.setImage(with: url)
            }
        }
    }
    
    var didTapOnImage: ((UIImage?) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        selectionStyle = .none
        
        addSubview(photoImageView)
        bringSubviewToFront(photoImageView)
        
        let constraints = [
            photoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16.0),
            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            photoImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            photoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.0),
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        setupGestureRecognizer()
    }
    
    private func setupGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onImageTapEvent))
        photoImageView.isUserInteractionEnabled = true
        photoImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func onImageTapEvent() {
        didTapOnImage?(photoImageView.image)
    }
    
}
