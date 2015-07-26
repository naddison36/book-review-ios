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

class AddBookViewController: UIViewController, UITextFieldDelegate
{
    var review: PFObject? = nil;
    
    //MARK: Outlets

    @IBOutlet weak var isbnField: UITextField!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var authorField: UITextField!
    @IBOutlet weak var publishedDateField: UITextField!
    @IBOutlet weak var publisherField: UITextField!
    @IBOutlet weak var bookDescriptionField: UITextView!
    
    @IBOutlet weak var reviewCommentField: UITextView!
    @IBOutlet weak var ratingField: UITextField!
    @IBOutlet weak var reviewerName: UITextField!
    @IBOutlet weak var imageView: PFImageView!

    @IBOutlet weak var searchActivityIndicator: UIActivityIndicatorView!
    
    //MARK: View Controller
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        isbnField.delegate = self
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        NSLog("Searching for book with ISBN \(isbnField.text)")
        
        if let isbn = isbnField.text
        {
            searchActivityIndicator.startAnimating()
            
            // get book details from API
            BooksManager.sharedInstance.getBook(isbn, callback: getBookHandler)
        }
        
        self.view.endEditing(true)
        
        return false
    }
    
    func setFields(review: PFObject)
    {
        if let book = review["book"] as? PFObject
        {
            isbnField.text = book["ISBN"] as? String
            titleField.text = book["title"] as? String
            authorField.text = book["author"] as? String
            publishedDateField.text = book["publishedDate"] as? String
            publisherField.text = book["publisher"] as? String
            bookDescriptionField.text = book["description"] as? String
            
            imageView.file = book["cover"] as? PFFile
            imageView.loadInBackground()
        }
        
        if let rating: NSNumber = review["rating"] as? NSNumber
        {
            ratingField.text = rating.stringValue
        }
        
        reviewCommentField.text = review["comments"] as? String
        
        if let reviewer = review["reviewer"] as? PFUser
        {
            reviewerName.text = reviewer.username
        }
    }

    //MARK: Actions
    
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
        book["publisher"] = publisherField.text
        book["publishedDate"] = publishedDateField.text
        book["description"] = bookDescriptionField.text
        
        self.review!["comments"] = reviewCommentField.text
        
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
    
    @IBAction func cancelToAddBookViewController(unwindSegue: UIStoryboardSegue)
    {
        if let sourceController = unwindSegue.sourceViewController as? BarcodeScanner
        {
            NSLog("unwind segue from barcode scanner with code \(sourceController.barcode)")
            
            isbnField.text = sourceController.barcode
            
            if let isbn = sourceController.barcode
            {
                // get book details from API
                BooksManager.sharedInstance.getBook(isbn, callback: getBookHandler)
            }
        }
    }
    
    func getBookHandler(error: NSError?, book: PFObject?)
    {
        searchActivityIndicator.stopAnimating()
        
        if let error = error
        {
            let alertController = UIAlertController(title: "Failed to get book details", message: error.description, preferredStyle: .Alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
        if let book = book
            where self.review == nil
        {
            NSLog("Got book with ISBN " + (book["ISBN"] as! String) +
                "and title " + (book["title"] as! String) )
            
            if let smallThumbnail: String = book["smallThumbnailURL"] as? String
            {
                NSURLConnection.sendAsynchronousRequest(
                    NSURLRequest(
                        URL: NSURL(string: smallThumbnail)!
                    ),
                    queue: NSOperationQueue.mainQueue(),
                    completionHandler:
                    {
                        (response, data, error) -> Void in
                        
                        let httpResponse = response as! NSHTTPURLResponse
                        
                        if httpResponse.statusCode == 200 && error == nil
                        {
                            // create a file from the returned data
                            let imageFile: PFFile = PFFile(name:"image.jpg", data: data)
                            imageFile.save()
                            
                            // set image in Parse book object
                            book.setObject(imageFile, forKey: "cover")
                            
                            // set downloaded image to image on screen
                            self.imageView.image = UIImage(data: data)
                        }
                    }
                )
            }
            
            self.createNewReview(book)
            
            self.setFields(self.review!)
        }
    }
    
    //MARK: Parse
    
    func createNewReview(book: PFObject?)
    {
        self.review = PFObject(className: "Review")
        
        if book == nil {
            self.review!["book"] = PFObject(className: "books")
        }
        else
        {
            self.review!["book"] = book
        }
        
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
            self.review!["reviewer"] = currentUser
        }
    }
}
