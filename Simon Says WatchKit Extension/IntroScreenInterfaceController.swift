//
//  IntroScreenInterfaceController.swift
//  Simon Says WatchKit Extension
//
//  Created by Charles Martin Reed on 1/9/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import WatchKit
import Foundation


class IntroScreenInterfaceController: WKInterfaceController {
    
    

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
    }
    
    //MARK:- IBActions
    @IBAction func startGameButtonTapped() {
        pushController(withName: "GameScreen", context: nil)
    }
    
}
