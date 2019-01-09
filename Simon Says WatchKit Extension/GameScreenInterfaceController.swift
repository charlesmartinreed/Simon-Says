//
//  InterfaceController.swift
//  Simon Says WatchKit Extension
//
//  Created by Charles Martin Reed on 1/8/19.
//  Copyright © 2019 Charles Martin Reed. All rights reserved.
//

import WatchKit
import Foundation
import AVFoundation

class GameScreenInterfaceController: WKInterfaceController {

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
    
    var highScore: Int!
    
    //which buttons are in this round's simon sequence and the indices of the ones the user must tap, respectively
    var sequence = [WKInterfaceButton]()
    var sequenceSound = [String]()
    
    //var testSequence = [[WKInterfaceButton: String]]()
    var sequenceIndex = 0
    var sequenceTimer = 0.8
    
    //sounds
    var session = AVAudioSession()
    var player = AVAudioPlayer()
    let redFXPath = Bundle.main.path(forResource: "redButtonFX", ofType: "wav")!
    let blueFXPath = Bundle.main.path(forResource: "blueButtonFX", ofType: "wav")!
    let greenFXPath = Bundle.main.path(forResource: "greenButtonFX", ofType: "wav")!
    let yellowFXPath = Bundle.main.path(forResource: "yellowButtonFX", ofType: "wav")!
    
    //somewhat equivalent to viewDidLoad()
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        highScore = UserDefaults.standard.value(forKey: "highScore") as? Int ?? 0
        
        initializeAVSession()
        startNewGame()
    }
    
    //MARK:- Game init methods
    func initializeAVSession() {
        //set up the session
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(.playback, mode: .default, policy: .longForm, options: [])
        } catch let error {
            fatalError("Unable to set up audio session: \(error.localizedDescription)")
        }
    }
    
    func startNewGame() {
        //clear the sequence and begin creation of a new one
        //testSequence.removeAll()
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
        let buttonTuple = (sequence[sequenceIndex], sequenceSound[sequenceIndex])
        sequenceIndex += 1
        sequenceTimer *= 0.010
        
        //wait a fraction of a second before making the button flash
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            [weak self] in
            //mark this button as being active and play the corresponding sound
            buttonTuple.0.setTitle("•")
            self?.playSoundFor(path: buttonTuple.1)

            
            //then, wait again before removing the title
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8, execute: {
                buttonTuple.0.setTitle("")
                self?.playNextSequenceItem()
            })
        }
    }

    func addToSequence() {
        //add a random button to the sequence
        //we're explicitly stating type here to remove the optionaity that would normally be present
        let colors = [redButton, yellowButton, blueButton, greenButton]
        let sounds = [redFXPath, yellowFXPath, blueFXPath, greenFXPath]
        
        
        let randomElement = Int.random(in: 0..<colors.count)
        sequence.append(colors[randomElement]!)
        sequenceSound.append(sounds[randomElement])
        
        //start the flashing at the beginning
        sequenceIndex = 0
        
        //update the player instructions
        isWatching = true
        
        //break before the player sees the next flash
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1) {
            self.playNextSequenceItem()
        }
    }
    
    //MARK:- Audio playback method
    func playSoundFor(path: String) {
        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
        } catch let error {
            fatalError("Could not playback sound: \(error.localizedDescription)")
        }
        
        player.play()
    }
    
    //MARK:- Animation method
    
    //MARK:- Check player input
    func makeMove(_ color: WKInterfaceButton) {
        //player can't touch while the game is in watch mode
        guard isWatching == false else { return }
        
        if sequence[sequenceIndex] == color {
            //correct input from player
            sequenceIndex += 1
            
            if sequenceIndex == sequence.count {
                //the end of the array, add new buttons for sequence
                addToSequence()
            }
        } else {
            //wrong input from player, game over
            //grab score, save new high score if necessary, display score to user
            let roundScore = sequence.count - 1
            
            let playAgain = WKAlertAction(title: "Play Again?", style: .default) {
                self.startNewGame()
            }
            let quitGame = WKAlertAction(title: "Quit", style: .default, handler: {
                self.pushController(withName: "IntroScreen", context: nil)
            })
            
            if roundScore > highScore {
                highScore = roundScore
                UserDefaults.standard.set("\(roundScore)", forKey: "highScore")
                
                presentAlert(withTitle: "A new high score!", message: "You scored \(roundScore).", preferredStyle: .actionSheet, actions: [playAgain, quitGame])
            } else {
                presentAlert(withTitle: "Game Over!", message: "You scored \(roundScore).", preferredStyle: .actionSheet, actions: [playAgain, quitGame])
            }
            
            //presentAlert(withTitle: "Game Over!", message: "You scored \(roundScore).", preferredStyle: .actionSheet, actions: [playAgain, quitGame])
        }
    }
    
    //MARK:- IBActions
    @IBAction func redTapped() {
        playSoundFor(path: redFXPath)
        makeMove(redButton)
    }
    
    @IBAction func greenTapped() {
        playSoundFor(path: greenFXPath)
        makeMove(greenButton)
    }
    
    @IBAction func blueTapped() {
        playSoundFor(path: blueFXPath)
        makeMove(blueButton)
    }
    
    @IBAction func yellowTapped() {
        playSoundFor(path: yellowFXPath)
        makeMove(yellowButton)
    }
    
    
}
