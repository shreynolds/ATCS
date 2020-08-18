//
//  AddTournamentViewController.swift
//  Tournaments
//
//  Created by Sophie Reynolds on 2/28/19.
//  Copyright © 2019 Sophie Reynolds. All rights reserved.
//

import UIKit

class AddTournamentViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    var newTournament = Tournament()
    var editingTournament = false
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberOfLocations: UITextField!
    @IBOutlet weak var numberOfDays: UITextField!
    @IBOutlet weak var tournamentType: UIPickerView!
    
    var pickerData = ["Single Elimination", "Double Elimination", "Play to Place", "Round Robin (3 games)", "Round Robin (4 games)", "Round Robin (play all teams)"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.numberOfLocations.keyboardType = UIKeyboardType.numberPad
        self.numberOfDays.keyboardType = UIKeyboardType.numberPad
        
        tournamentType.delegate = self
        tournamentType.dataSource = self

    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        if(editingTournament)
        {
            print("in if")
            title = "Edit Tournament"
            nameTextField.text = newTournament.name
            numberOfLocations.text = String(newTournament.locations.count)
            numberOfDays.text = String(newTournament.numDays)
            let row = pickerData.index(of: newTournament.type)
            tournamentType.selectRow(row ?? 0, inComponent: 0, animated: true)
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Capture the picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        newTournament.type = pickerData[row]
    }
    
    
    
    @IBAction func cancel ()
    {
        navigationController?.popViewController(animated:true)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "continueAdding"
        {
            newTournament.name = nameTextField.text ?? "Tournament"
            if newTournament.name == ""{
                newTournament.name = "Tournament"
            }
            newTournament.numDays = Int(numberOfDays.text ?? "1") ?? 1
            newTournament.numLocations = Int(numberOfLocations.text ?? "1") ?? 1
            
            let controller = segue.destination as! AddTournament2ViewController
            controller.newTournament = newTournament
            controller.editingTournament = editingTournament
        }
    }

    
}
