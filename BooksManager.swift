//
//  GoogleBooks.swift
//  BookReview
//
//  Created by Nicholas Addison on 22/07/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation
import Parse
import Alamofire
import SwiftyJSON

class BooksManager
{
    static let sharedInstance = BooksManager()
    
    func getBook(isbn: String, callback: (error: NSError?, book: PFObject?)->() )
    {
        Alamofire.request(
            GoogleBookRouter.SearchByISBN(isbn: isbn) )
            .responseJSON
            {
                request, response, json, error in
                
                if let error = error
                {
                    NSLog("Failed to call Google Books API: " + error.description)
                    
                    //FIXME:- wrap Alamofire error before returning
                    callback(error: error, book: nil)
                    return
                }
                else if let json: AnyObject = json
                {
                    // convert into a SwiftJSON struct
                    let json = JSON(json)
                    
                    NSLog("Successfully called Google Books API. JSON: " + json.description)
                    
                    if let items = json["items"].array
                    {
                        if  let firstItem = items.first
                        {
                            let book = PFObject(className: "books")
                            book["ISBN"] = isbn
                            
                            if let title = firstItem["volumeInfo","title"].string
                            {
                                if let subtitle = firstItem["volumeInfo","subtitle"].string
                                {
                                    book["title"] = title + ", " + subtitle
                                }
                                else
                                {
                                    book["title"] = title
                                }
                            }
                            else
                            {
                                println(firstItem["volumeInfo","title"].error)
                            }
                            
                            if let authors = firstItem["volumeInfo","authors"].array
                                where authors.count > 0
                            {
                                book["author"] = authors.first!.string
                            }
                            else
                            {
                                println(firstItem["volumeInfo","author"].error)
                            }
                            
                            if let publisher = firstItem["volumeInfo","publisher"].string
                            {
                                book["publisher"] = publisher
                            }
                            else
                            {
                                println(firstItem["volumeInfo","publisher"].error)
                            }
                            
                            if let publishedDate = firstItem["volumeInfo","publishedDate"].string
                            {
                                book["publishedDate"] = publishedDate
                            }
                            else
                            {
                                println(firstItem["volumeInfo","publishedDate"].error)
                            }
                            
                            if let description = firstItem["volumeInfo","description"].string
                            {
                                NSLog("description \(description)")
                                
                                book["description"] = description
                            }
                            else
                            {
                                println(firstItem["volumeInfo","description"].error)
                            }
                            
                            if let smallThumbnailURL = firstItem["volumeInfo","imageLinks","smallThumbnail"].string
                            {
                                NSLog("small thumbnail \(smallThumbnailURL)")
                                
                                book["smallThumbnailURL"] = smallThumbnailURL
                            }
                            else
                            {
                                println(firstItem["volumeInfo","imageLinks","smallThumbnail"].error)
                            }
                            
                            callback(error: nil, book: book)
                            return
                        }
                    }
                    else
                    {
                        NSLog("Failed to parse Google Books API")
                    }
                }
                else
                {
                    NSLog("Failed to call Google Books API. No JSON data was returned")
                }
        }
    }
}