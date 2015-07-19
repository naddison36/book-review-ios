//
//  AddBookViewController.swift
//  BookReview
//
//  Created by Nicholas Addison on 18/07/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class AddBookViewController: UIViewController
{
    var review: PFObject? = nil;

    @IBOutlet weak var isbnField: UITextField!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var authorField: UITextField!
    @IBOutlet weak var illustratorField: UITextField!
    @IBOutlet weak var publishedDateField: UITextField!
    @IBOutlet weak var commentField: UITextView!
    @IBOutlet weak var ratingField: UITextField!
    @IBOutlet weak var reviewerName: UITextField!
    @IBOutlet weak var imageView: PFImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // if existing review
        if let review = self.review
        {
            setFields(review)
        }
        // else new review
        else
        {
            reviewerName.text = PFUser.currentUser()?.username
        }
    }
    
    func setFields(review: PFObject)
    {
        if let book = review["book"] as? PFObject
        {
            isbnField.text = book["ISBN"] as? String
            titleField.text = book["title"] as? String
            authorField.text = book["author"] as? String
            illustratorField.text = book["illustrator"] as? String
            //publishedDateField.text = book["publishedDate"] as? NSDate
            
            imageView.file = book["cover"] as? PFFile
            imageView.loadInBackground()
        }
        
        if let rating: NSNumber = review["rating"] as? NSNumber
        {
            ratingField.text = rating.stringValue
        }
        
        commentField.text = review["comments"] as? String
        
        if let reviewer = review["reviewer"] as? PFUser
        {
            reviewerName.text = reviewer.username
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func saveAction(sender: AnyObject)
    {
        let book: PFObject
        
        if self.review == nil
        {
            self.review = PFObject(className: "Review")
            
            book = PFObject(className: "books")
            self.review!["book"] = book
            
            var currentUser = PFUser.currentUser()
            if currentUser != nil {
                self.review!["reviewer"] = currentUser
            }
        }
        else
        {
            if self.review!["book"] is PFObject
            {
                book = self.review!["book"] as! PFObject
            }
            else
            {
                book = PFObject(className: "books")
                self.review!["book"] = book
            }
        }
        
        book["ISBN"] = isbnField.text
        book["title"] = titleField.text
        book["author"] = authorField.text
        book["illustrator"] = illustratorField.text
        //book["publishedDate"] = publishedDateField.text
        
        self.review!["comments"] = commentField.text
        
        if let rating = ratingField.text {
            review!["rating"] = NSString(string: rating).floatValue
        }
        
        self.review!.saveInBackgroundWithBlock
        {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
                println(error?.description)
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
