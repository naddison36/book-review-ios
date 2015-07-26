//
//  GoogleBooksRouter.swift
//  BookReview
//
//  Created by Nicholas Addison on 23/07/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation
import Alamofire

enum GoogleBookRouter: URLRequestConvertible
{
    static let baseURLString = "https://www.googleapis.com/books/v1/volumes"
    
    case SearchByISBN(isbn: String)
    
    var parameters: [String: AnyObject]?
    {
        switch self {
        case .SearchByISBN(let isbn):
            return ["q": "isbn:\(isbn)"]
        }
    }
    
    var URLRequest: NSURLRequest {
        
        let url = NSURL(string: GoogleBookRouter.baseURLString)!
        let urlRequest = NSURLRequest(URL: url)
        let encoding = Alamofire.ParameterEncoding.URL
        
        return encoding.encode(urlRequest, parameters: parameters).0
    }
}