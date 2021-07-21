//
//  PlacesTableViewCell.swift
//  CyclingAssistant
//
//  Created by Alla Golovinova on 6/10/21.
//

import UIKit

class PlacesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imagePlace: UIImageView!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneNumberButton: UIButton!
    @IBOutlet weak var viewOnMapButton: UIButton!
    var selectedLatitude = Double()
    var selectedLongitude = Double()
    var currentTag = Int()
    
    weak var delegateCell: viewOnMapButtonTappedProtocol?
    
    var image_url: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func viewOnMapTapped(_ sender: UIButton) {
        sender.tag = currentTag
        self.delegateCell?.viewOnMapButtonTapped(sender: sender)
    }
    
    
}
