//
//  UitimateGameVC.swift
//  TheUltimatePokerWar
//
//  Created by Sun on 2025/3/21.
//

import UIKit

class UitimateGameVC: UIViewController {
    
    var deck: [(value: Int, suit: String)] = []
    var playerGrid: [[(value: Int, suit: String)]] = []
    var selectedCards: [(row: Int, col: Int)] = []
    var score = 0
    var timer: Timer?
    var timeRemaining = 60
    
    let suits = ["♠", "♥", "♦", "♣"]
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet var cardButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        DispatchQueue.main.async {
            self.showHowToPlay()
        }
    }
    
    func showHowToPlay() {
        let alert = UIAlertController(
            title: "How to Play",
            message: "1. Select two cards that sum to 10\n2. Matching pairs will be replaced with new cards\n3. Score points by finding as many pairs as possible\n4. You have 60 seconds to get the highest score!",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Start Game", style: .default) { [weak self] _ in
            self?.startNewGame()
        })
        present(alert, animated: true)
    }
    
    func startNewGame() {
        deck = Array(repeating: (1...9).map { ($0, suits.randomElement() ?? "♠") }, count: 4).flatMap { $0 }
        deck.shuffle()
        score = 0
        timeRemaining = 60
        selectedCards = []
        startTimer()
        fillGrid()
        updateScoreLabel()
    }
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.timeRemaining -= 1
            self.timerLabel.text = "Time: \(self.timeRemaining)s"
            if self.timeRemaining <= 0 {
                self.timer?.invalidate()
                self.showGameOver()
            }
        }
    }
    
    func fillGrid() {
        playerGrid.removeAll()
        
        for i in 0..<4 {
            var rowArray: [(Int, String)] = []
            for j in 0..<8 {
                let card = deck.popLast() ?? (1, "♠")
                rowArray.append(card)
                
                let button = cardButtons[i * 8 + j]
                button.setTitle("\(card.1)\(card.0)", for: .normal)
                button.isHidden = false
                button.layer.cornerRadius = 10
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.black.cgColor
                button.addTarget(self, action: #selector(cardTapped(_:)), for: .touchUpInside)
            }
            playerGrid.append(rowArray)
        }
    }
    
    @objc func cardTapped(_ sender: UIButton) {
        guard let index = cardButtons.firstIndex(of: sender) else { return }
        let row = index / 8
        let col = index % 8
        
        if selectedCards.contains(where: { $0 == (row, col) }) {
            selectedCards.removeAll { $0 == (row, col) }
            sender.layer.borderColor = UIColor.black.cgColor  // Reset border to black
        } else {
            selectedCards.append((row, col))
            sender.layer.borderColor = UIColor.white.cgColor   // Highlight with blue border
            
            if selectedCards.count == 2 {
                // Add a small delay to show both selections before processing
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                    guard let self = self else { return }
                    let firstCard = self.playerGrid[self.selectedCards[0].row][self.selectedCards[0].col]
                    let secondCard = self.playerGrid[self.selectedCards[1].row][self.selectedCards[1].col]
                    
                    if firstCard.value + secondCard.value == 10 {
                        self.score += 1
                        // Generate new random cards for both positions
                        for position in self.selectedCards {
                            let newValue = Int.random(in: 1...9)
                            let newSuit = self.suits.randomElement() ?? "♠"
                            self.playerGrid[position.row][position.col] = (newValue, newSuit)
                            
                            let button = self.cardButtons[position.row * 8 + position.col]
                            button.setTitle("\(newSuit)\(newValue)", for: .normal)
                            button.layer.borderColor = UIColor.black.cgColor  // Reset border to black
                        }
                        self.updateScoreLabel()
                    } else {
                        // Reset both cards' borders if they don't sum to 10
                        for position in self.selectedCards {
                            let button = self.cardButtons[position.row * 8 + position.col]
                            button.layer.borderColor = UIColor.black.cgColor  // Reset border to black
                        }
                    }
                    self.selectedCards.removeAll()
                }
            }
        }
    }
    
    func updateScoreLabel() {
        scoreLabel.text = "Score: \(score)"
    }
    
    func showGameOver() {
        let alert = UIAlertController(title: "Game Over", message: "Final Score: \(score)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: { _ in
            self.startNewGame()
        }))
        present(alert, animated: true)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)

    }
}
