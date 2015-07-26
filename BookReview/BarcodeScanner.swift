//
//  BarcodeScanner.swift
//  BookReview
//
//  Created by Nicholas Addison on 21/07/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import Foundation
import RSBarcodes_Swift

class BarcodeScanner: RSCodeReaderViewController
{
    var barcode: String? = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.focusMarkLayer.strokeColor = UIColor.redColor().CGColor
        
        self.cornersLayer.strokeColor = UIColor.yellowColor().CGColor
        
        self.tapHandler = { point in
            println(point)
        }
        
        self.barcodesHandler = { barcodes in
            
            // get the first barcode from the collection of barcodes
            if let barcode = barcodes.first
                where self.barcode == nil
            {
                self.barcode = barcode.stringValue
                
                println("Barcode found: type=" + barcode.type + " value=" + barcode.stringValue)
                
                self.performSegueWithIdentifier("cancelToAddBook", sender: self)
            }
        }
    }
}