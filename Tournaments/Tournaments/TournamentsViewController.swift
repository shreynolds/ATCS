//
//  ViewController.swift
//  Tournaments
//
//  Created by Sophie Reynolds on 2/26/19.
//  Copyright © 2019 Sophie Reynolds. All rights reserved.
//

import UIKit

class TournamentsViewController: UITableViewController {
    
    var TournamentJustAdded = Tournament()
    var justEditedTournament = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if TournamentJustAdded.name != "NOT MADE YET" && justEditedTournament == false {
            tournaments.append(TournamentJustAdded)
        }
    
        tableView.reloadData()
        TournamentJustAdded = Tournament() //new blank one so that it does not keep adding
        justEditedTournament = false
    }
    
    
    var tournaments = [Tournament]()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return tournaments.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyly: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        tournaments.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let tournament = tournaments[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tournament", for : indexPath)
        let label = cell.viewWithTag(10) as! UILabel
        label.text = tournament.name
        
        return cell
    }
    
    @IBAction func myUnwindAction(unwindSegue: UIStoryboardSegue)
    {
        //let sourceViewController = unwindSegue.source
    }
    
    
    //Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "seeTournament" {
            let controller = segue.destination as! BracketTableViewController
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
                controller.tournament = tournaments[indexPath.row]
            }
        }
    }

}

