//
//  RoversViewController.swift
//  MarsPhotos
//
//  Created by Евгений Нименко on 4/19/19.
//  Copyright © 2019 Евгений Нименко. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RoversViewController: UIViewController, StoryboardInitializable {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: RoversViewModel?

    private let bag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTable()
        configureViewModel()
    }
    
    private func setupTable() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40.0
        tableView.register(TextTableViewCell.self, forCellReuseIdentifier: "RoverCell")
    }
    
    private func configureViewModel() {
        viewModel?.dataSource.bind(to: tableView.rx.items(cellIdentifier: "RoverCell", cellType: TextTableViewCell.self)) { _, model, cell in
            cell.textSizingLabel.text = model.name
        }.disposed(by: bag)
        
        tableView.rx.modelSelected(Rover.self)
            .subscribe({ [weak self] rover in
                if let rover = rover.element {
                    self?.viewModel?.didSelectRover(rover)
                }
            }).disposed(by: bag)
    }
    
}
