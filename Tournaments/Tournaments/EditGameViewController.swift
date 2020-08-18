//
//  EditGameViewController.swift
//  Tournaments
//
//  Created by Sophie Reynolds on 3/5/19.
//  Copyright © 2019 Sophie Reynolds. All rights reserved.
//

import UIKit

protocol EditGameViewControllerDelegate: class {
    func editGameViewControllerDidCancel(_ controller: EditGameViewController)
    func editGameViewController (_ controller: EditGameViewController, didFinishScoring game: Game)
}

class EditGameViewController: UIViewController, UITextFieldDelegate {

    weak var delegate:EditGameViewControllerDelegate?
    
    @IBOutlet weak var team1Label: UILabel!
    @IBOutlet weak var team2Label: UILabel!
    @IBOutlet weak var team1Score: UITextField!
    @IBOutlet weak var team2Score: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        team1Label.text = currentGame.team1
        team2Label.text = currentGame.team2
        team1Score.delegate = self
        team2Score.delegate = self
        
        //https://stackoverflow.com/questions/35437604/ios-numeric-keyboard-with-decimal
        self.team1Score.keyboardType = UIKeyboardType.decimalPad
        self.team2Score.keyboardType = UIKeyboardType.decimalPad
    }
    
    var currentGame: Game!
    var allowTies = false

    @IBAction func cancel (){
        delegate?.editGameViewControllerDidCancel(self)
    }
    
    func setDoneButtonStatus() -> Bool {
        if team1Score.text != "" && team2Score.text != "" && team1Score.text != team2Score.text{
            return true
        } else if team1Score.text == team2Score.text && allowTies {
            return true
        }
        return false
    }
    
    @IBAction func done (){
        if setDoneButtonStatus(){
            if let game = currentGame{
                game.score1 = Double(team1Score.text!)!
                game.score2 = Double(team2Score.text!)!
                delegate?.editGameViewController(self, didFinishScoring: game)
            }
        } else if team1Score.text == "" || team2Score.text == "" {
            let alert = UIAlertController(title: "Error", message : "Scores cannot be empty", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else if team1Score.text == team2Score.text {
            let alert = UIAlertController(title: "Error", message : "Scores cannot be the same", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        
    }

}
