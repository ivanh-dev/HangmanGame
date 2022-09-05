//
//  HangmanVC.swift
//  Hangman
//
//  Created by Ivan Hirsinger on 03.09.2022..
//

import UIKit

class HangmanVC: UIViewController {
    
    var hangmanWords = [String]()
    var randomWord: String?
    var hiddenWord = ""
    var solutionArray = [String]()
    var hangmanCharacterView: UIImageView!
    
    var allButtons = [UIButton]()
    var alphabet = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X"]
    
    var hangmanImagesNames: [String]?
    
    var answerField: UITextField!
    
    var wrongCounter = 0
    
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.loadLevel()
            self.setHangmanCharacterView()
            self.setAnswerField()
            self.setButtonsView()
        }
    }
    
    
    func setHangmanCharacterView() {
        hangmanCharacterView = UIImageView()
        hangmanCharacterView.translatesAutoresizingMaskIntoConstraints = false
        if wrongCounter < 7 {
            hangmanCharacterView.image = UIImage(named: hangmanImagesNames?[wrongCounter] ?? "")
        } else {
            hangmanCharacterView.image = UIImage(named: hangmanImagesNames?[0] ?? "")
        }
        
        hangmanCharacterView.backgroundColor = .lightGray
        view.addSubview(hangmanCharacterView)
        
        NSLayoutConstraint.activate([
            hangmanCharacterView.topAnchor.constraint(equalTo: view.topAnchor),
            hangmanCharacterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hangmanCharacterView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hangmanCharacterView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
    }
    
    
    func setAnswerField() {
        randomWord = hangmanWords.randomElement()
        
        guard randomWord != nil else {
            print("No random word generated.")
            return
        }
        
        solutionArray = (randomWord?.components(separatedBy: " "))!
        
        for _ in 0...randomWord!.count {
            hiddenWord.append(" ? ")
        }
        
        answerField = UITextField()
        answerField.translatesAutoresizingMaskIntoConstraints = false
        answerField.text = hiddenWord
        answerField.textAlignment = .center
        answerField.font = UIFont.systemFont(ofSize: 30)
        answerField.layer.borderWidth = 1
        answerField.layer.borderColor = UIColor.lightGray.cgColor
        answerField.layer.cornerRadius = 10
        answerField.isUserInteractionEnabled = false
        view.addSubview(answerField)
        
        NSLayoutConstraint.activate([
            answerField.topAnchor.constraint(equalTo: hangmanCharacterView.bottomAnchor, constant: 20),
            answerField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            answerField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    
    func setButtonsView() {
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.layer.borderWidth = 1
        buttonsView.layer.borderColor = UIColor.lightGray.cgColor
        buttonsView.layer.cornerRadius = 10
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            buttonsView.topAnchor.constraint(equalTo: answerField.bottomAnchor, constant: 20),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9, constant: 12),
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -30)
        ])
        
        let width = 60
        let height = 70
        
        for row in 0..<4 {
            for column in 0..<6 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
                letterButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
                letterButton.setTitle("W", for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton)
                allButtons.append(letterButton)
            }
        }
        
        if alphabet.count == allButtons.count {
            for letter in 0..<alphabet.count {
                allButtons[letter].setTitle(alphabet[letter], for: .normal)
            }
        }
    }
    
    
    @objc func letterTapped(letterButton: UIButton) {
        
        let letter = letterButton.titleLabel?.text!.lowercased()
        
        guard randomWord != nil else {
            return
        }
        
        answerField.text = answerField.text! + letterButton.titleLabel!.text!.lowercased()
        
        if solutionArray.contains(letter!) {
            print("Working")
        } else {
            wrongCounter += 1
            setHangmanCharacterView()
        }
    }
    
    
    func loadLevel() {
        // Fill hangmanWords array with possible words
        if let hangmanWordsURL = Bundle.main.url(forResource: "hangmanWords", withExtension: ".txt") {
            if let startWord = try? String(contentsOf: hangmanWordsURL) {
                hangmanWords = startWord.components(separatedBy: "\n")
            }
        }
        
        // Fill hangmanImages array with images
        hangmanImagesNames = ["Hangman0", "Hangman1", "Hangman2", "Hangman3", "Hangman4", "Hangman5", "Hangman6"]
    }
}

