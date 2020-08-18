//
//  BracketTableViewController.swift
//  Tournaments
//
//  Created by Sophie Reynolds on 3/5/19.
//  Copyright © 2019 Sophie Reynolds. All rights reserved.
//

import UIKit

class BracketTableViewController: UITableViewController, EditGameViewControllerDelegate, FilterTableDelegate {
    

    @IBOutlet weak var editTeamsButton: UIBarButtonItem!
    @IBOutlet weak var seeFinalRankingButton: UIBarButtonItem!
    
    var filterIndex = [IndexPath]()
    
    func FilterDidCancel(_ controller: FilterTableViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func FilterTableViewController(_ controller: FilterTableViewController, selected array: [String],info index: [IndexPath] ) {
        filteredArray = tournament.games
        let selection = array
        let dateSelection = selection[0]
        let locationSelection = selection[1]
        let teamSelection = selection[2]
        if dateSelection != "All Days" {
            filteredArray = filteredArray.filter{$0.date.description.contains(dateSelection) == true}
        }
        if locationSelection != "All Locations" {
            filteredArray = filteredArray.filter{$0.location == locationSelection}
        }
        if teamSelection != "All Teams"{
            filteredArray = filteredArray.filter{$0.team1 == teamSelection || $0.team2 == teamSelection}
        }
        tableView.reloadData()
        filterIndex = index
        navigationController?.popViewController(animated: true)
    }
    
    func editGameViewControllerDidCancel(_ controller: EditGameViewController) {
        navigationController?.popViewController(animated:true)
    }
    
    func editGameViewController(_ controller: EditGameViewController, didFinishScoring game: Game) {
        tournament.gamesDone += 1
        let winnerGame = game.winnerGame
        let loserGame = game.loserGame
        if let index = tournament.games.firstIndex(of: game)
        {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath)
            {
                var score1 = String(game.score1)
                let num1 = score1.split(separator: ".")
                if(num1[1] == "0")
                {
                    score1 = String(num1[0])
                }
                let label3 = cell.viewWithTag(3) as! UILabel
                label3.text = score1
                //https://stackoverflow.com/questions/46418128/how-to-get-substring-with-specific-ranges-in-swift-4
                //^^getting substrings of things
                var score2 = String(game.score2)
                let num2 = score2.split(separator: ".")
                if(num2[1] == "0")
                {
                    score2 = String(num2[0])
                }
                let label4 = cell.viewWithTag(4) as! UILabel
                label4.text = score2
            }
        }
        
        var winningTeam:String!
        var losingTeam: String!
        if(game.score1 > game.score2)
        {
            winningTeam = game.team1
            losingTeam = game.team2
        } else {
            winningTeam = game.team2
            losingTeam = game.team1
        }
        if(winnerGame != 0)
        {
            let nextGame = tournament.games[winnerGame-1]
            if(tournament.numTeams == 7)
            {
                if(game.gameNumber%2 == 1){nextGame.team2 = winningTeam}
                else {nextGame.team1 = winningTeam}
            }
            else if tournament.numTeams == 12
            {
                if game.gameNumber < 5{
                    nextGame.team2 = winningTeam
                } else{
                    if game.gameNumber % 2 == 1 {nextGame.team1 = winningTeam}
                    else {nextGame.team2 = winningTeam}
                }
            }
            else
            {
                if game.gameNumber % 2 == 1 {
                    if nextGame.team1.contains("Winner"){
                        nextGame.team1 = winningTeam
                    } else {
                        nextGame.team2 = winningTeam
                    }
                    
                }
                else {
                    if nextGame.team2.contains("Winner"){
                        nextGame.team2 = winningTeam
                    } else {
                        nextGame.team1 = winningTeam
                    }
                    
                }
            }
        
            let nextGameIndexPath = IndexPath(row: winnerGame-1, section:0)
            if let cell = tableView.cellForRow(at: nextGameIndexPath)
            {
                let team1 = cell.viewWithTag(1) as! UILabel
                team1.text = nextGame.team1
                let team2 = cell.viewWithTag(2) as! UILabel
                team2.text = nextGame.team2
            }
        }
        if loserGame != 0{
            let nextGame = tournament.games[loserGame - 1]
            if game.gameNumber % 2 == 1 {
                if nextGame.team1.contains("Loser"){
                    nextGame.team1 = losingTeam
                } else {
                    nextGame.team2 = losingTeam
                }
                
            }
            else {
                if nextGame.team2.contains("Loser"){
                    nextGame.team2 = losingTeam
                } else {
                    nextGame.team1 = losingTeam
                }
                
            }
            let nextGameIndexPath = IndexPath(row: loserGame-1, section:0)
            if let cell = tableView.cellForRow(at: nextGameIndexPath)
            {
                let team1 = cell.viewWithTag(1) as! UILabel
                team1.text = nextGame.team1
                let team2 = cell.viewWithTag(2) as! UILabel
                team2.text = nextGame.team2
            }
        }
        filteredArray = tournament.games
        self.tableView.reloadData()
        navigationController?.popViewController(animated:true)
    }
    

    var tournament:Tournament!
    var filteredArray = [Game]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = tournament.name
        filteredArray = tournament.games
        filterIndex = [[0,0], [1,0], [2,0]]
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        //getting rid of edit teams if you have already started the tournament
        if tournament.gamesDone != 0
        {
            print(" in if ")
            self.editTeamsButton.isEnabled = false
            self.editTeamsButton.tintColor = UIColor.clear
            self.editTeamsButton.width = 0.1
        }
        
        //only can see the final rankings when the tournament is over
        if tournament.gamesDone != tournament.games.count {
            self.seeFinalRankingButton.isEnabled = false
            self.seeFinalRankingButton.tintColor = UIColor.clear
            self.seeFinalRankingButton.width = 0.1
        }
        else {
            self.seeFinalRankingButton.isEnabled = true
            self.seeFinalRankingButton.width = 0 //default to normal
            self.seeFinalRankingButton.tintColor = UIColor.blue
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return filteredArray.count
    }
    
    //https://stackoverflow.com/questions/25632394/swift-uitableview-set-rowheight
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100.0;//Choose your custom row height
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let game = filteredArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "Game", for : indexPath)
        
        let label1 = cell.viewWithTag(1) as! UILabel
        label1.text = game.team1
        
        let label2 = cell.viewWithTag(2) as! UILabel
        label2.text = game.team2
        
        var score1 = String(game.score1)
        let num1 = score1.split(separator: ".")
        if(num1[1] == "0")
        {
            score1 = String(num1[0])
        }
        let label3 = cell.viewWithTag(3) as! UILabel
        label3.text = score1
        //https://stackoverflow.com/questions/46418128/how-to-get-substring-with-specific-ranges-in-swift-4
        //^^getting substrings of things
        var score2 = String(game.score2)
        let num2 = score2.split(separator: ".")
        if(num2[1] == "0")
        {
            score2 = String(num2[0])
        }
        let label4 = cell.viewWithTag(4) as! UILabel
        label4.text = score2
        
        //get the substring of the time from the date, and get it out of military time
        let label5 = cell.viewWithTag(5) as! UILabel
        let gameTime = game.time
        let mySubstring = gameTime.description.suffix(14)
        let newSubstring = mySubstring.prefix(5)
        var time = String(newSubstring)
        let num3 = time.split(separator: ":")
        if(num3[0] < "12")
        {
            time = time + " am"
        }
        else if (num3[0] == "12")
        {
            time = time + " pm"
        }
        else
        {
            time = String(Int(num3[0])! - 12) + ":" + num3[1] + " pm"
        }
        label5.text = time
        
        let label6 = cell.viewWithTag(6) as! UILabel
        label6.text = String(game.gameNumber)
        
        let label7 = cell.viewWithTag(7) as! UILabel
        label7.text = game.notes
        
        let label8 = cell.viewWithTag(8) as! UILabel
        var description = game.date.description
        description = String(description.prefix(11))
        description = String(description.suffix(6))
        label8.text = description
        
        let label9 = cell.viewWithTag(9) as! UILabel
        label9.text = game.location
        
        return cell
    }
    
    @IBAction func back (){
        navigationController?.popViewController(animated:true)
    }
    
    //Navigation
    
    //https://stackoverflow.com/questions/8066525/prevent-segue-in-prepareforsegue-method
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "enterScore"  {
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
                let game = filteredArray[indexPath.row]
                if game.score1 != 0 && game.score2 != 0{
                    return  false
                }
                if game.team1.contains("Winner") || game.team2.contains("Winner") || game.team1.contains("Loser") || game.team2.contains("Loser") //teams not set
                {
                    return  false
                }
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "enterScore" {
            let controller = segue.destination as! EditGameViewController
            controller.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
                controller.currentGame = filteredArray[indexPath.row]
            }
            if tournament.type == "Round Robin (3 games)" || tournament.type == "Round Robin (4 games)" || tournament.type == "Round Robin (play all teams)"{
                controller.allowTies = true
            } else {
                controller.allowTies = false
            }
            
        }
        
        else if segue.identifier == "editTournament" {
            let controller = segue.destination as! AddTournamentViewController
            controller.newTournament = tournament
            controller.editingTournament = true
        }
        
        else if segue.identifier == "filterBracket"{
            let controller = segue.destination as! FilterTableViewController
            controller.locations = tournament.locations
            controller.teams = tournament.teams
            var days = [String]()
            for x in 0...(tournament.numDays - 1) {
                let date = tournament.date + (Double(x) * TimeInterval(86400))
                var description = date.description
                description = String(description.prefix(11))
                description = String(description.suffix(6))
                days.append(description)
            }
            controller.days = days
            controller.selected = filterIndex
            controller.delegate = self
        }
        
        else if segue.identifier == "showRankings"{
            let controller = segue.destination as! FinalRankingsTableViewController
            controller.tournament = tournament
        }
    }


}
