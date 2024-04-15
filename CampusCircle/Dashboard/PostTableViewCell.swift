//
//  PostTableViewCell.swift
//  CampusCircle
//
//  Created by mac-high-13 on 06/03/24.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var profileName: UILabel!
    @IBOutlet var postTextView: UITextView!
    @IBOutlet var postImage: UIImageView!
    
    @IBOutlet var postTextHeightConstaint: NSLayoutConstraint!
    @IBOutlet var postImageHightConstraint: NSLayoutConstraint!
    @IBOutlet var likeBtn: UIButton!
    @IBOutlet var commentBtn: UIButton!
    @IBOutlet var shareBtn: UIButton!
    
    @IBOutlet var loader: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
