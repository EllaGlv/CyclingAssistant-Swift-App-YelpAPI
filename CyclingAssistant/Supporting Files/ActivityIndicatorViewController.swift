//
//  ActivityIndicatorViewController.swift
//  CyclingAssistant
//
//  Created by Alla Golovinova on 6/25/21.
//

import UIKit

var spinner = UIActivityIndicatorView(style: .large)

class ActivityIndicatorViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.7)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)
        
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
}
