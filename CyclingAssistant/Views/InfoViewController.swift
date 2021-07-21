//
//  InfoViewController.swift
//  CyclingAssistant
//
//  Created by Alla Golovinova on 6/9/21.
//

import UIKit

// Loads simple info about the App

class InfoViewController: UIViewController {
    
    @IBOutlet weak var infoView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoView.layer.cornerRadius = 10
    }
    
    @IBAction func dismissPopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
