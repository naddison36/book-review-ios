//
//  GoogleBooksTests.swift
//  BookReview
//
//  Created by Nicholas Addison on 22/07/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import UIKit
import XCTest

class BooksManagerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testGetBookWithISBN()
    {
        
        let expectation = expectationWithDescription("getBook")
        
        BooksManager.sharedInstance.getBook("9781741664515")
        {
            error, book in
            
            XCTAssertNotNil(book)
            
            if let book = book {
                XCTAssertNotNil(book["ISBN"])
                XCTAssertEqual(book["ISBN"] as! String, "9781741664515")
                
                XCTAssertNotNil(book["title"])
                
                if let title: String = book["title"] as? String {
                    XCTAssertEqual(title, "Alice-Miranda at School")
                }
                
                XCTAssertNotNil(book["author"])
                
                if let author: String = book["author"] as? String {
                    XCTAssertEqual(author, "Jacqueline Harvey")
                }
            }
            
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(30) { (error) in
            // don't need to do anything after the tests are completed
        }
    }
}
