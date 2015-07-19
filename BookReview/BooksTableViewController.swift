//
//  BooksTableViewController.swift
//  BookReview
//
//  Created by Nicholas Addison on 9/07/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class BooksTableViewController: PFQueryTableViewController
{
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        
        self.parseClassName = "books"
//        self.textKey = "name"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: "Review")
        query.includeKey("book")
        query.includeKey("reviewer")
        return query
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject!) -> PFTableViewCell?
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("bookCell", forIndexPath: indexPath) as! BookTableViewCell
        
        if let book = object["book"] as? PFObject
        {
            cell.titleField.text = book["title"] as? String
            cell.authorField.text = book["author"] as? String
        }
        
        if let rating: NSNumber = object["rating"] as? NSNumber
        {
            cell.ratingField.text = rating.stringValue
        }
        
        if let reviewer = object["reviewer"] as? PFObject
        {
            cell.reviewerField.text = reviewer["username"] as? String
        }
        
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if let addBookViewController = segue.destinationViewController.topViewController as? AddBookViewController
        {
            if segue.identifier == "editBook"
            {
                // Pass the selected object to the destination view controller.
                if let indexPath = self.tableView.indexPathForSelectedRow()
                {
                    addBookViewController.review = objects![indexPath.row] as? PFObject
                }
            }
            else if segue.identifier == "addBook"
            {
                addBookViewController.review = nil
            }
        }
    }
}
