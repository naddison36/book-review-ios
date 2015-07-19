//
//  ReviewTableViewCell.swift
//  BookReview
//
//  Created by Nicholas Addison on 10/07/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import UIKit
import ParseUI

class ReviewTableViewCell: PFTableViewCell
{
    
    @IBOutlet weak var reviewerField: UILabel!
    @IBOutlet weak var ratingField: UILabel!
    @IBOutlet weak var commentField: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
