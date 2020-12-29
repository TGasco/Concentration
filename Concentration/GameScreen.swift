//
//  GameScreen.swift
//  Concentration
//
//  Created by Thomas Gascoyne on 24/11/2020.
//

import UIKit
import CoreData
class GameScreen: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource  {

//    Initialising class variables
    var turnCounter: Int = 1
    var winner: String = ""
    var pairsFound: [Int] = [0, 0]
    var gameOver: Bool = false
    var cardArr: [String] = []
    var cardsArrShuffled: [String] = []
    var isFaceDown: [Int] = [Int](repeating: 0, count: 30)
    var numSelected = 0
    var selectedCards: [String] = []
    var selectedCardsIndex: [IndexPath] = []
    var counter = 0
    let multiplayer = mode.instance.multiplayer
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var hiScores: [Hi_Scores]?
    var hiScoresMulti: [Multiplayer]?
    let start = Date()
    
//    Initialising StoryboardUI elements
    @IBOutlet weak var turnNo: UILabel!
    
    @IBOutlet weak var matchesNo: UILabel!
    
    @IBOutlet weak var matchesP2: UILabel!
    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet weak var turnIndicator: UILabel!
    
    @IBAction func exitButtonPressed(_ sender: Any) {
        displayAlert(gameWon: "Are you sure you want to exit?")
    }
    
//    function declares number of items in the collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
//    sets the images displayed at a given cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
        if isFaceDown[indexPath[1]] == 0 {
            cell.configure(with: UIImage(named: "FaceDown")!)
        } else {
            cell.configure(with: UIImage(named: cardsArrShuffled[indexPath[1]])!)}
        return cell
    }
    
//    called when user taps on a cell (one of the cards)
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedItemFirst(indexPath: indexPath)
    }
    
//    Updates the UILabel 'turnIndicator' to reflect who's turn it is
    func updateTurnIndicator(player: String) -> Int {
        turnIndicator.text = "It's Player \(player)'s turn"
        return Int(player)!-1
    }
    
//    Updates the UILabel 'turnNo' to reflect how many turns have been played
    func updateTurnNo() {
        turnNo.text = "Turn: " + String(turnCounter)
    }
    
//    Updates the matches label on screen to reflect how many matches each player has found
    func updateMatches(pointer: Int) {
        if multiplayer == true {
            if pointer == 0 {
                matchesNo.text = "Matches P1: " + String(pairsFound[pointer])
            } else {
                matchesP2.text = "Matches P2: " + String(pairsFound[pointer])
            }
        } else {
            matchesNo.text = "Matches: " + String(pairsFound[0])
        }
        
    }
    
//    Shuffles the array of cards so that the images are randomised
//    Returns shuffled array of cards
    func shuffleCards() -> [String] {
        let suits = ["hearts", "diamonds", "spades", "clubs"]
        let numbers = ["ace", "2", "3", "4", "5", "6", "7", "8", "9", "10", "jack", "queen", "king"]
//        for loop concatenates the arrays 'suits' and 'numbers' into a new array, which equals the
//        filenames of the images in assets
        for suit in suits {
            for number in numbers {
                cardArr.append("\(number)_of_\(suit)")
            }
        }
        cardsArrShuffled = cardArr.shuffled()
        var cardPairs: [String] = []
        for index in 0...14 {
            for _ in 0...1 {
                cardPairs.append(cardsArrShuffled[index])
            }
        }
        cardsArrShuffled = cardPairs.shuffled()
        return cardsArrShuffled
    }
    
//    Updates the 'isFaceDown' element at the index path accociated with cell user tapped on
//    1 indicates the card has been overturned & cell should be reloaded to reflect
    func updateOverturnedCards(cardsArrShuffled: [String], indexPath: IndexPath) -> Int {
        isFaceDown[indexPath[1]] = 1
        return isFaceDown[indexPath[1]]
    }
    
    
//    Compares whether the 2 cards selected by the player are a match
    func compareCards(pairIndex: Int, indexes: [IndexPath], pointer: Int) -> Bool {
        var found: Bool = false
        print(indexes)
        let indexPath1: IndexPath = indexes[0]
        let indexPath2: IndexPath = indexes[1]
        if indexPath1[1] == pairIndex {
            print("PAIR!")
            found = true
            pairsFound[pointer] += 1
            if pointer == 0 {
                
            }
            updateMatches(pointer: pointer)
//            gameEnd()
            
        } else {
            found = false
            print("path1: \(indexPath1)     path2: \(indexPath2)")
            print("NO PAIR")
            isFaceDown[indexPath1[1]] = 0
            isFaceDown[indexPath2[1]] = 0
        }
        gameEnd()
        return found
    }
    
    
//    updates cells to turns cards back over if cards are not a match
    func updateCards() {
        collectionView.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + (difficulty.instance.timeDelay)) { [self] in
            collectionView.reloadItems(at: [self.selectedCardsIndex[0]])
            collectionView.reloadItems(at: [self.selectedCardsIndex[1]])
            selectedCardsIndex.removeAll()
            selectedCards.removeAll()
            collectionView.isUserInteractionEnabled = true
        }
    }
    
//    Checks whether conditions have been met to end the game
    func gameEnd() {
        let elapsedTime = Int(start.timeIntervalSinceNow*(-1))
        if turnCounter == 30 {
            displayAlert(gameWon: "Game Over! You ran out of turns")
            saveScore(elapsedTime: elapsedTime)
        } else {
            var sum = 0
            for elements in isFaceDown {
                if elements == 1 {
                    sum+=1
                }
            }
            if sum == 30 {
                if multiplayer == true {
                    if pairsFound[0] > pairsFound[1] {
                        displayAlert(gameWon: "Player 1 Wins!")
                        winner = "Player 1"
                    }
                    if pairsFound[0] < pairsFound[1] {
                        displayAlert(gameWon: "Player 2 Wins!")
                        winner = "Player 2"
                    } else {
                        displayAlert(gameWon: "It's a draw!")
                        winner = "Draw"
                    }
                } else {
                    print("YOU WON")
                    displayAlert(gameWon: "You won!")
                }
                print("Elapsed time: \(elapsedTime) seconds")
                saveScore(elapsedTime: elapsedTime)
            }
        }
    }
//    Saves statistics of match to CoreData to be recalled in a different session
    func saveScore(elapsedTime: Int) {
        if mode.instance.multiplayer == true {
            let newHi_Score = Multiplayer(context: context)
            newHi_Score.p1Score = Int64(pairsFound[0])
            newHi_Score.p2Score = Int64(pairsFound[1])
            newHi_Score.winner = winner
        } else {
            let newHi_Score = Hi_Scores(context: context)
            newHi_Score.turns = Int64((elapsedTime/turnCounter)*100)
            newHi_Score.timeElapsed = Int64(elapsedTime)
        }
        
        do {
            try self.context.save()
        } catch {}
    }
    
    //displays a popup alert message to indicate to the user the game has ended
    //gives them options to play again, or quit to main menu
    func displayAlert(gameWon: String) {
        let gameOverPopup = UIAlertController(title: gameWon, message: "Would you like to play again?", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Play Again", style: .default, handler: { (action) -> Void in
            print("OK button tapped")
            self.resetGame()
        })
        let backButton  = UIAlertAction(title: "Back to main menu", style: .default, handler: {(_)in
            self.performSegue(withIdentifier: "unwindToMain", sender: self)
        })
        gameOverPopup.addAction(okButton)
        gameOverPopup.addAction(backButton)
        if gameWon == "Are you sure you want to exit?" {
            let cancelButton = UIAlertAction(title: "cancel", style: .cancel) { (UIAlertAction) in}
            gameOverPopup.addAction(cancelButton)
        }
        self.present(gameOverPopup, animated: true, completion: nil)
    }
    
    
//    resets all variables back to their default state to play a new game
    func resetGame() {
        turnCounter = 1
        updateTurnNo()
        pairsFound = [0, 0]
        
        cardArr.removeAll()
        cardsArrShuffled = shuffleCards()
        for index in 0...(isFaceDown.count-1) {
            isFaceDown[index] = 0
            collectionView.reloadItems(at: [[0, index]])
        }
    }
    
    
    //sets layout of collectionView cells
    func collectionViewSetup() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 90, height: 110)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = layout
    }
    
//    Handles the selected item
//    SPLIT FUNCTION UP IF POSSIBLE!
    func selectedItemFirst(indexPath: IndexPath) {
        numSelected += 1
        isFaceDown[indexPath[1]] = updateOverturnedCards(cardsArrShuffled: cardsArrShuffled, indexPath: indexPath)
        collectionView.deselectItem(at: indexPath, animated: true)
        selectedCardsIndex.append(indexPath)
        findPair(cardsArrShuffled: cardsArrShuffled, indexPath: indexPath)
        selectedCards.append(cardsArrShuffled[indexPath[1]])
        
        collectionView.reloadItems(at: [indexPath])
        
        if numSelected == 2 {
            selectedItemSecond(indexPath: indexPath)
        }
    }
    
    
    func selectedItemSecond(indexPath: IndexPath) {
        let playerPointer = counter%2
        numSelected = 0
        //let pairIndex = findPair(cardsArrShuffled: cardsArrShuffled, indexPath: indexPath)
        let found = compareCards(pairIndex: findPair(cardsArrShuffled: cardsArrShuffled, indexPath: indexPath),
                                 indexes: selectedCardsIndex, pointer: playerPointer)
        if found == false {
            updateCards()
        } else {
            self.selectedCardsIndex.removeAll()
            self.selectedCards.removeAll()
        }
        if multiplayer == true {
            counter += 1
            playerTurn()
        } else {
            turnCounter += 1
            updateTurnNo()
        }
    }

    //Finds and prints the index of the card paired with the one selected, used for testing purposes
    func findPair(cardsArrShuffled: [String], indexPath: IndexPath) -> Int {
        let pair1Found = cardsArrShuffled.firstIndex(of: cardsArrShuffled[indexPath[1]])!
        let pair2Found = cardsArrShuffled.lastIndex(of: cardsArrShuffled[indexPath[1]])!
        var pairIndex: Int
        if pair1Found == indexPath[1] {
            pairIndex = pair2Found
        } else {
            pairIndex = pair1Found
        }
        // remove comments to allow it to print the index of the pair, to make it easier to find for testing (CHEATING!)
//        print("the selectedCards for \(indexPath) is at [0, \(String(describing: pairIndex))]")

        return pairIndex
    }
    
//    determines which players turn it is
    func playerTurn() -> Int {
        var playerPointer: Int
        if counter % 2 == 1 {
            playerPointer = updateTurnIndicator(player: "2")
        } else {
            turnCounter += 1
            playerPointer = updateTurnIndicator(player: "1")
            updateTurnNo()
        }
        return playerPointer
    }
    
    
//    Determines which mode the user is playing (single, or multiplayer)
//    Updates whether the turnIndicator is displayed or not (as it is unneccesary for singleplayer)
    func modeType() {
        if multiplayer == true {
            turnIndicator.isHidden = false
        } else {
            turnIndicator.isHidden = true
            matchesP2.isHidden = true
            matchesNo.text = "Matches: \(pairsFound[0])"
        }
    }
    
    
    //    loads the UI elements and other initial setup
        override func viewDidLoad() {
            modeType()
            super.viewDidLoad()
            collectionViewSetup()
            updateTurnNo()
            cardsArrShuffled = shuffleCards()
        }
}



    
 
