//
//  ViewController.swift
//  Concentration
//
//  Created by Thomas Gascoyne on 24/11/2020.
//

import UIKit

class Main: UIViewController {
    @IBAction func didTapSingleplayer(_ sender: Any) {
        mode.instance.multiplayer = false
    }
    
    @IBAction func didTapMultiplayer(_ sender: Any) {
        mode.instance.multiplayer = true
    }
    
    @IBAction func didTapHiScores(_ sender: Any) {
    }
    
    @IBAction func didTapDifficulty(_ sender: Any) {
        displayAlert()
    }
    
    @IBAction func unwindToMain(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
    
    
    func displayAlert() {
        let gameOverPopup = UIAlertController(title: "Difficulty", message: "Set the difficulty", preferredStyle: .alert)
        let easyButton = UIAlertAction(title: "Easy", style: .default, handler: { (action) -> Void in
            difficulty.instance.timeDelay = 2
            print("Easy button tapped")
        })
        let normalButton  = UIAlertAction(title: "Normal (Default)", style: .default, handler: {(_)in
            difficulty.instance.timeDelay = 1
            print("Normal button tapped")
        })
        let hardButton  = UIAlertAction(title: "Hard", style: .default, handler: {(_)in
            difficulty.instance.timeDelay = 0.5
            print("Hard button tapped")
        })
        let extremeButton  = UIAlertAction(title: "You think you have a photographic memory", style: .default, handler: {(_)in
            difficulty.instance.timeDelay = 0.2
            print("Good Luck :)")
        })
        gameOverPopup.addAction(easyButton)
        gameOverPopup.addAction(normalButton)
        gameOverPopup.addAction(hardButton)
        gameOverPopup.addAction(extremeButton)
        let cancelButton = UIAlertAction(title: "cancel", style: .cancel) { (UIAlertAction) in}
        gameOverPopup.addAction(cancelButton)
        self.present(gameOverPopup, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }


}


class mode {
    static let instance = mode()
    
    private init() {
        
    }
    
    var multiplayer = false
}

class difficulty {
    static let instance = difficulty()
    
    private init() {
        
    }
    
    var timeDelay: Double = 1
}

