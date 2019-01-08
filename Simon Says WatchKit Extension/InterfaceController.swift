//
//  InterfaceController.swift
//  Simon Says WatchKit Extension
//
//  Created by Charles Martin Reed on 1/8/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {

    //MARK:- IBOutlets
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    //MARK:- IBActions
    @IBAction func redTapped() {
    }
    
    @IBAction func greenTapped() {
    }
    
    @IBAction func blueTapped() {
    }
    
    @IBAction func yellowTapped() {
    }
    
    
}
