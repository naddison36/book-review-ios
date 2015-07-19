//
//  ReviewsViewController.swift
//  BookReview
//
//  Created by Nicholas Addison on 10/07/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation

import UIKit
import Parse
import ParseUI

class ReviewTableViewController: PFQueryTableViewController
{
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        
        //self.parseClassName = "Review"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery
    {
        let query = PFQuery(className: "Review")
        query.includeKey("book")
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject!) -> PFTableViewCell?
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("reviewCell", forIndexPath: indexPath) as! PFTableViewCell
        
        //cell.titleField.text = object["name"] as! String;
        
        return cell
    }
}
