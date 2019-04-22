//
//  TextTableViewCell.swift
//  MarsPhotos
//
//  Created by Евгений Нименко on 4/19/19.
//  Copyright © 2019 Евгений Нименко. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell {
    
    let textSizingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(textSizingLabel)
        
        let constraints = [
            textSizingLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16.0),
            textSizingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            textSizingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            textSizingLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16.0)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
}
