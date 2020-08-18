//
//  FinalRankingsTableViewController.swift
//  Tournaments
//
//  Created by Sophie Reynolds on 4/22/19.
//  Copyright © 2019 Sophie Reynolds. All rights reserved.
//

import UIKit

class FinalRankingsTableViewController: UITableViewController {

    var tournament = Tournament()
    var displayArray = [String]() //generate this somewhere and then display it
    
    var places = ["1st", "2nd", "3rd", "4th", "5th", "6th", "7th", "8th", "9th", "10th", "11th", "12th", "13th", "14th", "15th", "16th"]
    override func viewDidLoad() {
        super.viewDidLoad()
        //displayArray = ["1st", "2nd", "3rd"]
        if tournament.type == "Single Elimination" {
            generateSingleElimination()
        }
        else if tournament.type == "Play to Place" {
            generatePlayToPlace()
        }
        else {
            generateRoundRobin()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return displayArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ranking", for: indexPath)
        let labelText = cell.viewWithTag(200) as! UILabel
        labelText.text = displayArray[indexPath.row]
        return cell
    }
    
    
    @IBAction func back(_ sender: Any) {
        navigationController?.popViewController(animated:true)
    }
    
    func generateSingleElimination(){
        let numTeams = tournament.numTeams
        let lastGame = tournament.games[tournament.games.count - 1]
        let score1 = lastGame.score1
        let score2 = lastGame.score2
        if score1 > score2 {
            displayArray.append("1st: " + lastGame.team1)
            displayArray.append("2nd: " + lastGame.team2)
        } else {
            displayArray.append("1st: " + lastGame.team2)
            displayArray.append("2nd: " + lastGame.team1)
        }
    }
    
    func generatePlayToPlace(){
        let gamesPerRound = tournament.numTeams / 2
        let totalGames = tournament.games.count
        var indexCounter = 1
        for x in totalGames-gamesPerRound ... totalGames - 1{
            let game = tournament.games[x]
            let notes = game.notes
            let num = notes.components(separatedBy: " ").first
            let score1 = game.score1
            let score2 = game.score2
            //x is 2 --> index is 0
            //x is 3 --> index is
            if score1 > score2 {
                displayArray.append(num! + ": " + game.team1)
                displayArray.append(places[indexCounter] + ": " + game.team2)
            }
            else {
                displayArray.append(num! + ": " + game.team2)
                displayArray.append(places[indexCounter] + ": " + game.team1)
            }
            indexCounter += 2
        }
        print(displayArray)
        displayArray.sort()
        print(displayArray)
        
    }
    
    func generateRoundRobin(){
        var results = [Double]()
        for _ in 0...tournament.numTeams - 1{
            results.append(0.0)
        }
        for game in tournament.games {
            if game.score1 > game.score2{
                let winnerLoc = tournament.teams.index(of: game.team1)
                results[winnerLoc!] += 1
            }
            else if game.score2 > game.score1 {
                let winnerLoc = tournament.teams.index(of: game.team2)
                results[winnerLoc!] += 1
            }
            else{
                let loc1 = tournament.teams.index(of: game.team1)
                let loc2 = tournament.teams.index(of: game.team2)
                results[loc1!] += 0.5
                results[loc2!] += 0.5
            }
        }
        var couples = [(score: Double, team: String)]()
        for _ in 0...tournament.numTeams - 1{
            couples.append((0, ""))
        }
        for x in 0...tournament.numTeams - 1{
            couples[x].0 = results[x]
            couples[x].1 = tournament.teams[x]
        }
        couples.sort(by: {$0.score > $1.score}) //https://stackoverflow.com/questions/42568577/swift-3-sorting-an-array-of-tuples
        print(couples)
        for x in 0 ... tournament.numTeams - 1{
            displayArray.append (String(x+1) + ": " + couples[x].1)
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
