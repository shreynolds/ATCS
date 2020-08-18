//
//  AddTournament2ViewController.swift
//  Tournaments
//
//  Created by Sophie Reynolds on 3/26/19.
//  Copyright © 2019 Sophie Reynolds. All rights reserved.
//

import UIKit

class AddTournament2ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var newTournament = Tournament ()
    var editingTournament = false
    
    @IBOutlet weak var earliestGame: UIDatePicker!
    @IBOutlet weak var gameLength: UIDatePicker!
    @IBOutlet weak var firstDay: UIDatePicker!
    @IBOutlet weak var numberOfTeams: UIPickerView!
    
    var singleEliminationPicker = [4, 5, 6, 7, 8, 9, 10, 12, 16, 32, 64]
    var roundRobinPicker = [3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
    var playToPlacePicker = [4, 8, 16] //32 soon?
    var doubleEliminationPicker = [4, 8]
    var currentPicker = [Int]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberOfTeams.delegate = self
        numberOfTeams.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currentPicker.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(currentPicker[row])
    }
    
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        newTournament.numTeams = currentPicker[row]
        print(newTournament.numTeams)
    }
    

    
    override func viewDidAppear(_ animated: Bool)
    {
        if newTournament.type == "Play to Place"{ currentPicker = playToPlacePicker}
        else if newTournament.type == "Single Elimination" {currentPicker = singleEliminationPicker}
        else if newTournament.type == "Double Elimination" {currentPicker = doubleEliminationPicker}
        else {currentPicker = roundRobinPicker}
        numberOfTeams.reloadAllComponents()
        
        if(editingTournament)
        {
            title = "Edit Tournament"
            earliestGame.date = newTournament.firstGame + TimeInterval(28800)
            //gameLength.timeInterval = newTournament.timeInterval
            firstDay.date = newTournament.date
            let row = currentPicker.index(of: newTournament.numTeams)
            numberOfTeams.selectRow(row ?? 0, inComponent: 0, animated: true)
            gameLength.countDownDuration = newTournament.timeInterval
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated:true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "addTeams")
        {
            newTournament.date = firstDay.date - TimeInterval(28800)
            newTournament.firstGame = earliestGame.date - TimeInterval(28800)
            //subtract so that we get to our time zone
            newTournament.timeInterval = gameLength.countDownDuration
            if newTournament.numTeams == 0 { //they never moved the picker view
                newTournament.numTeams = 4
            }
            
            let controller = segue.destination as! AddTeamsViewController
            controller.newTournament = newTournament
            controller.editingTournament = editingTournament
        }
    }
}
