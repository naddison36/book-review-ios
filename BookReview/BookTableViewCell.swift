//
//  BookTableViewCell.swift
//  BookReview
//
//  Created by Nicholas Addison on 9/07/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import UIKit
import ParseUI

class BookTableViewCell: PFTableViewCell
{

    @IBOutlet weak var titleField: UILabel!
    @IBOutlet weak var authorField: UILabel!
    @IBOutlet weak var ratingField: UILabel!
    @IBOutlet weak var reviewerField: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
