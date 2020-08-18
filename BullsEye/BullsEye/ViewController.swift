//
//  ViewController.swift
//  BullsEye
//
//  Created by Sophie Reynolds on 1/9/19.
//  Copyright © 2019 Sophie Reynolds. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var currentValue: Int = 0
    var targetValue = 0
    var score : Int = 0
    var round : Int = 0
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let thumbImageNormal = UIImage(named: "SliderThumb-Normal")!
        //slider.setThumbImage(thumbImageNormal, for : .normal)
        //let thumbImageHighlighted = UIImage (named: "SliderThumb-Highlighted")!
        //slider.setThumbImage(thumbImageHighlighted, for : .highlighted)
        
        startNewRound()
        updateLabels()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //IB = interface builder
    //notify the interface builder that they want to be able to look there
    @IBAction func ShowAlert(){
        let difference = abs(targetValue-currentValue)
        var points = 100 - difference
        let title : String
        if difference == 0{
            points += 100
            title = "Perfect!"
        }
        else if difference < 5{
            points += 50
            title = "Almost!"
        }
        else{
            title = "Not even close!"
        }
        updateScore(Int(points))
        let message = "The slider value = \(currentValue) \n The goal = \(targetValue) \n You scored \(points) points"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Next try", style: .default, handler: {_ in self.startNewRound()})
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func showInfo(){
        let message = "To play this game, place the target as close as possible to the target value. The slider goes from 1 to 100"
        let alert = UIAlertController(title: "Info", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK!", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    //params: calling name, internal name, type
    //return value: () -> return type
    // \(...) is string interpolation, will be evaluated and then stuck in as a string
    
    @IBAction func SliderMoved( _ slider: UISlider){
        currentValue = lroundf(slider.value)
    }
    
    func updateScore(_ add: Int){
        score += add
    }
    
    func updateLabels(){
        targetLabel.text = String(targetValue)
        roundLabel.text = String(round)
        scoreLabel.text = String(score)
    }
    
    func startNewRound(){
        targetValue = Int.random(in: 1...100)
        currentValue = 50
        slider.value = Float(currentValue)
        round += 1
        updateLabels()
    }
    
    @IBAction func startOver() {
        score = 0
        round = 0
        startNewRound()
    }
    
}
