//
//  UitmateMathCardGameVC.swift
//  TheUltimatePokerWar
//
//  Created by Sun on 2025/3/21.
//

import UIKit

class UitmateMathCardGameVC: UIViewController {
    
    @IBOutlet weak var player1CardImage: UIImageView!
    @IBOutlet weak var player2CardImage: UIImageView!
    @IBOutlet weak var player1ScoreLabel: UILabel!
    @IBOutlet weak var player2ScoreLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var ruleLabel: UILabel!
    @IBOutlet weak var nextRoundButton: UIButton!
    
    var deck: [Int] = Array(1...52).shuffled()
    var player1Deck: [Int] = []
    var player2Deck: [Int] = []
    var currentRule: String = ""
    var player1Score = 0
    var player2Score = 0
    let cardBackImage = UIImage(named: "card_back")
    let rules = [
        "More than",
        "Less than",
        "Same Suit Wins",
        "Even Wins",
        "Odd Wins",
        "Prime Number Wins",
        "Multiple of 3 Wins",
        "Face Card Wins",
        "Lowest Card Wins",
        "Highest Card Wins"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        splitDeck()
        updateScores()
        showRule()
    }
    
    func splitDeck() {
        let halfDeck = deck.count / 2
        player1Deck = Array(deck[0..<halfDeck])
        player2Deck = Array(deck[halfDeck..<deck.count])
    }
    
    func showRule() {
        currentRule = rules.randomElement()!
        ruleLabel.text = "Rule: \(currentRule)"
        nextRoundButton.isHidden = false
    }
    
    func nextRound() {
        if player1Deck.isEmpty || player2Deck.isEmpty {
            declareWinner()
            return
        }
        
        let card1 = player1Deck.removeFirst()
        let card2 = player2Deck.removeFirst()
        
        player1CardImage.image = cardBackImage
        player2CardImage.image = cardBackImage
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.flipCard(self.player1CardImage, toImageNamed: "\(card1)")
            self.flipCard(self.player2CardImage, toImageNamed: "\(card2)")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.determineWinner(card1: card1, card2: card2)
        }
    }
    
    func flipCard(_ imageView: UIImageView, toImageNamed imageName: String) {
        UIView.transition(with: imageView, duration: 0.6, options: .transitionFlipFromRight, animations: {
            imageView.image = UIImage(named: imageName)
        }, completion: nil)
    }
    
    func getSuit(_ card: Int) -> String {
        switch card {
        case 1...13:
            return "Clubs"
        case 14...26:
            return "Spades"
        case 27...39:
            return "Hearts"
        case 40...52:
            return "Diamonds"
        default:
            return "Unknown"
        }
    }
    
    func isPrime(_ num: Int) -> Bool {
        if num < 2 { return false }
        for i in 2..<num {
            if num % i == 0 { return false }
        }
        return true
    }
    
    func isFaceCard(_ card: Int) -> Bool {
        let rank = (card - 1) % 13 + 1
        return rank == 11 || rank == 12 || rank == 13
    }
    
    func determineWinner(card1: Int, card2: Int) {
        var player1Wins = false
        var player2Wins = false
        
        switch currentRule {
        case "More than":
            player1Wins = card1 > card2
            player2Wins = card1 < card2
        case "Less than":
            player1Wins = card1 < card2
            player2Wins = card1 > card2
        case "Same Suit Wins":
            player1Wins = getSuit(card1) == getSuit(card2)
            player2Wins = !player1Wins
        case "Even Wins":
            player1Wins = card1 % 2 == 0
            player2Wins = card2 % 2 == 0
        case "Odd Wins":
            player1Wins = card1 % 2 != 0
            player2Wins = card2 % 2 != 0
        case "Prime Number Wins":
            player1Wins = isPrime(card1)
            player2Wins = isPrime(card2)
        case "Multiple of 3 Wins":
            player1Wins = card1 % 3 == 0
            player2Wins = card2 % 3 == 0
        case "Face Card Wins":
            player1Wins = isFaceCard(card1)
            player2Wins = isFaceCard(card2)
        case "Lowest Card Wins":
            player1Wins = card1 < card2
            player2Wins = card1 > card2
        case "Highest Card Wins":
            player1Wins = card1 > card2
            player2Wins = card1 < card2
        default:
            break
        }
        
        if player1Wins {
            resultLabel.text = "Player 1 wins this round!"
            player1Score += 1
            player1Deck.append(contentsOf: [card1, card2])
        } else if player2Wins {
            resultLabel.text = "Player 2 wins this round!"
            player2Score += 1
            player2Deck.append(contentsOf: [card1, card2])
        } else {
            resultLabel.text = "It's a tie!"
        }
        
        updateScores()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.player1CardImage.image = self.cardBackImage
            self.player2CardImage.image = self.cardBackImage
            self.resultLabel.text = ""
            self.showRule()
        }
    }
    
    @IBAction func nextRoundTapped(_ sender: UIButton) {
        nextRoundButton.isHidden = true
        nextRound()
    }
    
    func updateScores() {
        player1ScoreLabel.text = "Player 1: \(player1Score)"
        player2ScoreLabel.text = "Player 2: \(player2Score)"
    }
    
    func declareWinner() {
        nextRoundButton.isHidden = true
        let winner = player1Score > player2Score ? "Player 1" : "Player 2"
        resultLabel.text = "\(winner) wins the game!"
    }
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)

    }
}
