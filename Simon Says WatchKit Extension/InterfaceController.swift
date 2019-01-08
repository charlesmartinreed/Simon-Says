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
    @IBOutlet weak var redButton: WKInterfaceButton!
    @IBOutlet weak var greenButton: WKInterfaceButton!
    @IBOutlet weak var blueButton: WKInterfaceButton!
    @IBOutlet weak var yellowButton: WKInterfaceButton!
    
    
    //MARK:- Properties
    var isWatching = true {
        didSet {
            if isWatching {
                setTitle("WATCH THE PATTERN!")
            } else {
                setTitle("YOUR TURN!")
            }
        }
    }
    //which buttons are in this round's simon sequence and the indices of the ones the user must tap, respectively
    var sequence = [WKInterfaceButton]()
    var sequenceIndex = 0
    
    //somewhat equivalent to viewDidLoad()
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        startNewGame()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    //MARK:- Game init methods
    func startNewGame() {
        //clear the sequence and begin creation of a new one
        sequence.removeAll()
        addToSequence()
    }
    
    //MARK:- Sequencing playback methods
    func playNextSequenceItem() {
        //stop flashing if the sequence if complete
        guard sequenceIndex < sequence.count else {
            isWatching = false
            sequenceIndex = 0
            return
        }
        
        //otherwise, move the sequence forward
        let button = sequence[sequenceIndex]
        sequenceIndex += 1
        
        //wait a fraction of a second before making the button flash
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            [weak self] in
            //mark this button as being active
            button.setTitle("•")
            
            //then, wait again before removing the title
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                button.setTitle("")
                self?.playNextSequenceItem()
            })
        }
    }
    
    func addToSequence() {
        //add a random button to the sequence
        //we're explicitly stating type here to remove the optionaity that would normally be present
        let colors: [WKInterfaceButton] = [redButton, yellowButton, blueButton, greenButton]
        sequence.append(colors.randomElement()!)
        
        //start the flashing at the beginning
        sequenceIndex = 0
        
        //update the player instructions
        isWatching = true
        
        //break before the player sees the next flash
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
            self.playNextSequenceItem()
        }
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
