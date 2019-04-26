//
//  LoadIndicatorViewController.swift
//  PopUpCorn
//
//  Created by Elias Paulino on 17/02/19.
//  Copyright © 2019 Elias Paulino. All rights reserved.
//

import UIKit

class LoadIndicatorViewController: UIViewController {

    private lazy var loadIndicator: UIActivityIndicatorView = {
        let loadIndicator = UIActivityIndicatorView.init()
        loadIndicator.color = UIColor.red
        loadIndicator.hidesWhenStopped = true
        loadIndicator.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.7)

        return loadIndicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(loadIndicator)
        view.backgroundColor = UIColor.clear
        loadIndicator.isUserInteractionEnabled = false
        view.isUserInteractionEnabled = false
        formatIndicator()
    }

    func formatIndicator() {
        loadIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadIndicator.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        loadIndicator.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        loadIndicator.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        loadIndicator.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }

    func startAnimating() {
        loadIndicator.isUserInteractionEnabled = true
        view.isUserInteractionEnabled = true
        loadIndicator.startAnimating()
    }

    func stopAnimating() {
        loadIndicator.isUserInteractionEnabled = false
        view.isUserInteractionEnabled = false
        loadIndicator.stopAnimating()
    }
}
