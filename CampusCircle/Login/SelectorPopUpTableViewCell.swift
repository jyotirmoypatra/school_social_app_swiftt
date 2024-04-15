//
//  SelectorPopUpTableViewCell.swift
//  CampusCircle
//
//  Created by mac-high-13 on 01/03/24.
//

import UIKit

class SelectorPopUpTableViewCell: UITableViewCell {

    
    
    
    @IBOutlet var cardView: UIView!
    @IBOutlet var schoolName: UILabel!
    @IBOutlet var schoolAddress: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

    
}
