//
//  AddTeamsViewController.swift
//  Tournaments
//
//  Created by Sophie Reynolds on 3/5/19.
//  Copyright © 2019 Sophie Reynolds. All rights reserved.
//

import UIKit

class AddTeamsViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var randomSeedingSwitch: UISwitch!
    
    var newTournament = Tournament()
    var editingTournament = false
    
    
    //multilevel and double elimination tournaments cannot usually be described mathematically -- they have quirks that depend on the number of teams. there are no algorithms online for these tournaments. instead, I have made it so that I have written down all of the pertinent information in arrays of tuples
    let multiNext4 = [(3,4), (3,4)]
    let multiPrev4 = [("Winner 1", "Winner 2"), ("Loser 1", "Loser 2")]
    let multiNote4 = ["Semi", "Semi", "1st Place", "3rd Place"]
    let multiNext8 = [(5, 7), (5,7), (6, 8), (6, 8), (9, 10), (9, 10), (11,12), (11,12)]
    let multiPrev8 = [("Winner 1", "Winner 2"), ("Winner 3", "Winner 4"), ("Loser 1", "Loser 2"), ("Loser 3", "Loser 4"), ("Winner 5", "Winner 6"), ("Loser 5", "Loser 6"), ("Winner 7", "Winner 8"), ("Loser 7", "Loser 8")]
    let multiNote8 = ["1-4 semi", "1-4 semi", "5-8 semi", "5-8 semi", "1st place", "3rd place", "5th place", "7th place"]
    let multiNext16 = [(10,9), (10, 9), (12, 11), (12, 11), (14, 13), (14, 13), (16, 15), (16, 15), (23, 21), (19, 17), (23, 21), (19, 17), (24, 22), (20, 18), (24, 22), (20, 18), (26, 25), (26, 25), (28, 27), (28, 27), (30, 29), (30, 29), (32, 31), (32, 31)]
    let multiPrev16 = [("Loser 1", "Loser 2"), ("Winner 1", "Winner 2"), ("Loser 3", "Loser 4"), ("Winner 3", "Winner 4"), ("Loser 5", "Loser 6"), ("Winner 5", "Winner 6"), ("Loser 7", "Loser 8"), ("Winner 7", "Winner 8"), ("Loser 10", "Loser 12"), ("Loser 14", "Loser 16"), ("Winner 10", "Winner 12"), ("Winner 14", "Winner 16"), ("Loser 9", "Loser 11"), ("Loser 13", "Loser 15"), ("Winner 9", "Winner 11"), ("Winner 13", "Winner 15"), ("Loser 17", "Loser 18"), ("Winner 17", "Winner 18"), ("Loser 19", "Loser 20"), ("Winner 19", "Winner 20"), ("Loser 21", "Loser 22"), ("Winner 21", "Winner 22"), ("Loser 23", "Loser 24"), ("Winner 23", "Winner 24")]
    let multiNote16 = ["5-8 semi", "5-8 semi", "1-4 semi", "1-4 semi", "13-16 semi", "13-16 semi", "9-12 semi", "9-12 semi", "7th place", "5th place", "3rd place", "1st place", "15th place", "13th place", "11th place", "9th place"]
    
    let doubleNext4 = [(3,4), (3,4), (6,5), (5,0), (6,0), (7, 7)]
    let doublePrev4 = [("Winner 1", "Winner 2"), ("Loser 1", "Loser 2"), ("Loser 3", "Winner 4"), ("Winner 3", "Winner 5"), ("Winner 6", "Loser 6")]
    let doubleNext8 = [(7, 5), (7, 5), (8, 6), (8, 6), (9, 0), (10, 0), (11, 10), (11, 9), (12, 0), (12, 0), (14, 13), (13, 0), (14, 0), (15, 15)]
    let doublePrev8 = [("Loser 1", "Loser 2"), ("Loser 3", "Loser 4"), ("Winner 1", "Winner 2"), ("Winner 3", "Winner 4"), ("Winner 5","Loser 8"), ("Loser 7", "Winner 6"), ("Winner 7", "Winner 8"), ("Winner 9", "Winner 10"), ("Loser 11", "Winner 12"), ("Winner 11", "Winner 13"), ("Winner 14", "Loser 14")]
    
    var currentNext = [(Int, Int)]()
    var currentPrev = [(String, String)]()
    var currentNote = [String]()
    
    
    var teams = [String]()
    var teamTextFields = [UITextField]()
    
    var locations = [String]()
    var locationTextFields = [UITextField]()
    
    var tempTeams = [String]()
    var tempLocs = [String]()
    
    var textPlaceholder = 0
    var textType = ""
    var currentTextField = UITextField()
    
    //for seeding
    var numGamesMade = 1
    var gamesInFirstRound = 0
    var nextGame = 0.0
    var winnerFrom = 1.0
    var currentTime = [Date]()
    var currentDate = 0
    
    var currentRoundOfDay = 1
    var roundsPerDay = 0
    var gamesPerLoc = 0
    var currentLoc = 0
    var currentGame = 1

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        gamesInFirstRound = newTournament.numTeams / 2
        nextGame = Double(gamesInFirstRound + 1)
        for _ in 0 ... newTournament.numLocations {
            currentTime.append(newTournament.firstGame)
        }
        if(editingTournament)
        {
            title = "Edit Teams"
        }
        if newTournament.type == "Play to Place"{
        if(newTournament.numTeams == 4)
        {
            currentNext = multiNext4
            currentPrev = multiPrev4
            currentNote = multiNote4
        } else if newTournament.numTeams == 8 {
            currentNext = multiNext8
            currentPrev = multiPrev8
            currentNote = multiNote8
        } else {
            currentNext = multiNext16
            currentPrev = multiPrev16
            currentNote = multiNote16
        }
        }
        else {
            if newTournament.numTeams == 4 {
                currentNext = doubleNext4
                currentPrev = doublePrev4
            } else {
                currentNext = doubleNext8
                currentPrev = doublePrev8
            }
        }
        if editingTournament{
            tempTeams = newTournament.teams
            if tempTeams.count < newTournament.numTeams {
                for _ in 0 ... (newTournament.numTeams - tempTeams.count){
                    tempTeams.append("")
                }
            }
            tempLocs = newTournament.locations
            if tempLocs.count < newTournament.numLocations {
                for _ in 0 ... (newTournament.numLocations - tempLocs.count){
                    tempLocs.append("")
                }
            }
        }
        else{
            tempTeams = Array(repeating: "", count: newTournament.numTeams)
            tempLocs = Array(repeating: "", count: newTournament.numLocations)
        }
        
        print(newTournament.locations)
        print(newTournament.numLocations)
        
    }
    
    
    override func numberOfSections(in: UITableView) -> Int
    {
        return 2
    }
    
    override func tableView(_: UITableView, titleForHeaderInSection: Int) -> String?
    {
        if titleForHeaderInSection == 0
        {
            return "Teams"
        }
        else
        {
            return "Locations"
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section:Int) -> Int
    {
        if section == 0
        {
            return newTournament.numTeams
        }
        else
        {
            return newTournament.numLocations
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Team", for : indexPath)
        let textField = cell.viewWithTag(15) as! UITextField
        textField.delegate = self
        if indexPath.section == 0
        {
            textField.placeholder = "Seed #" + String(indexPath.row + 1)
            if(editingTournament && indexPath.row < newTournament.teams.count)
            {
                textField.text = newTournament.teams[indexPath.row]
            }
            else if tempTeams[indexPath.row] != ""{
                textField.text = tempTeams[indexPath.row]
            } else {
                textField.text = ""
            }
            teamTextFields.append(textField)
        }
        else
        {
            if(editingTournament && indexPath.row < newTournament.locations.count)
            {
                textField.text = newTournament.locations[indexPath.row]
            }
            else if tempLocs[indexPath.row] != ""{
                textField.text = tempLocs[indexPath.row]
            } else {
                textField.text = ""
            }
            textField.placeholder = "Location #" + String(indexPath.row + 1)
            locationTextFields.append(textField)
        }
        return cell
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentTextField = textField
        let placeholder = (textField.placeholder!)
        if(placeholder.contains("Seed"))
        {
            textType = "Seed"
            var thing = placeholder.suffix(2)
            if thing.contains ("#"){
                thing = thing.suffix(1)
            }
            textPlaceholder = Int(thing)! - 1
        }
        else
        {
            textType = "Location"
            var thing = placeholder.suffix(2)
            if thing.contains ("#"){
                thing = thing.suffix(1)
            }
            textPlaceholder = Int(thing)! - 1
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        if textType == "Seed"
        {
            tempTeams[textPlaceholder] = textField.text ?? ""
        }
        else
        {
            tempLocs[textPlaceholder] = textField.text ?? ""
        }
    }
    
    
    @IBAction func back (){
        navigationController?.popViewController(animated:true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "finishAdding"{
            textFieldDidEndEditing(currentTextField)
            currentTextField = UITextField()
            if tempTeams.count > newTournament.numTeams {
                tempTeams = Array(tempTeams.prefix(newTournament.numTeams))
            }
            for x in 0...(tempTeams.count - 1) {
                if tempTeams[x] == "" {
                    tempTeams[x] = "Team " + String(x + 1)
                }
            }
            teams = tempTeams
            newTournament.teams = teams
            
            if randomSeedingSwitch.isOn {
                newTournament.teams.shuffle()
                teams.shuffle()
            }
            
            locations = tempLocs
            if locations.count > newTournament.numLocations {
                locations = Array(locations.prefix(newTournament.numLocations))
            }
            for x in 0...(locations.count - 1){
                if locations[x] == ""{
                    locations[x] = "Location " + String(x + 1)
                }
            }
            newTournament.locations = locations
            print(locations)
            
            //getting rid of the games if they already exist (if editing)
            let games = [Game]()
            newTournament.games = games
            
            if(newTournament.type == "Single Elimination")
            {
                createSingleEliminationTournament()
            }
            else if (newTournament.type == "Play to Place")
            {
                createMultilevelTournament()
            }
            else if newTournament.type == "Double Elimination"
            {
                createDoubleEliminationTournament()
            }
            else {
                var numGames = -1
                if newTournament.type == "Round Robin (3 games)"{
                    numGames = 3
                }
                else if newTournament.type == "Round Robin (4 games)" {
                    numGames = 4
                }
                createRoundRobinTournament(numGames)
            }
            
            let controller = segue.destination as! TournamentsViewController
            controller.TournamentJustAdded = newTournament
            if(editingTournament) {
                controller.justEditedTournament = true
            }
        }
    }
    
    func createDoubleEliminationTournament(){
        let numTeams = newTournament.numTeams
        let limit = Int(log2(Double(numTeams))) + 1
        createRoundOneDouble(seed: 1, level: 1, limit: limit)
        let numGames = 2 * numTeams - 1
        let gamesPerDay = Int(numGames/newTournament.numDays)
        let gamesPerLocation = Int(gamesPerDay/newTournament.numLocations)
        numGamesMade = numTeams/2 + 1
        var currentNumGamesLoc = numGamesMade
        var currentNumGamesDay = numGamesMade
        for index in (numTeams/2 + 1) ... numGames {
            let game = Game()
            let prev = currentPrev[index - (numTeams/2) - 1]
            game.team1 = prev.0
            game.team2 = prev.1
            game.gameNumber = numGamesMade
            if index != numGames {
                let thisGame = currentNext[numGamesMade - 1]
                game.winnerGame = thisGame.0
                game.loserGame = thisGame.1
            } else {
                game.notes = "if necessary"
            }
            numGamesMade += 1
            game.time = currentTime[currentLoc]
            game.date = newTournament.date + (Double(currentDate) * TimeInterval(86400))
            currentTime[currentLoc] = currentTime[currentLoc] + newTournament.timeInterval
            game.location = locations[currentLoc]
            newTournament.games.append(game)
            
            if currentNumGamesDay == gamesPerDay && currentDate < newTournament.numDays - 1 {
                currentDate += 1
                for loc in 0...(newTournament.numLocations - 1) {
                    currentTime[loc] = newTournament.firstGame
                }
                currentNumGamesDay = 0
            }
            currentNumGamesDay += 1
        }
        
    }
    
    func createRoundOneDouble(seed: Int, level: Int, limit: Int){
        let levelSum = pwrInt(2, level) + 1
        if limit == level + 1
        {
            let game = Game()
            game.team1 = teams[seed - 1]
            game.team2 = teams[levelSum - seed - 1]
            let thisGame = currentNext[numGamesMade - 1]
            game.gameNumber = numGamesMade
            game.winnerGame = thisGame.0
            game.loserGame = thisGame.1
            newTournament.games.append(game)
            numGamesMade += 1
            game.time = currentTime[currentLoc]
            game.date = newTournament.date + (Double(currentDate) * TimeInterval(86400))
            currentTime[currentLoc] = currentTime[currentLoc] + newTournament.timeInterval
            game.location = locations[currentLoc]
            return
        }
        else if seed % 2 == 1
        {
            createRoundOneDouble(seed: seed, level: level + 1, limit: limit);
            createRoundOneDouble(seed: levelSum - seed, level: level + 1, limit: limit);
        }
        else
        {
            createRoundOneDouble(seed: levelSum - seed, level: level + 1, limit: limit)
            createRoundOneDouble(seed: seed, level: level + 1, limit: limit)
        }
        
    }
    
    func createMultilevelTournament()
    {
        let numTeams = newTournament.numTeams
        let numRounds = Int(log2(Double(numTeams)))
        let gamesPerRound = numTeams / 2
        roundsPerDay = numRounds / newTournament.numDays
        print(roundsPerDay)
        gamesPerLoc = gamesPerRound / newTournament.numLocations
        
        createRoundOneMulti(seed: 1, level: 1, limit: numRounds + 1)
        if currentRoundOfDay == roundsPerDay && currentDate < newTournament.numDays - 1{
            currentDate += 1
            currentRoundOfDay = 0
            for loc in 0...(newTournament.numLocations - 1){
                currentTime[loc] = newTournament.firstGame
            }
            currentGame = 1
            currentLoc = 0
        }
        
        currentRoundOfDay += 1
        
        for round in 2 ... numRounds {
            currentGame = 1
            currentLoc = 0
            var notes = false
            if round >= numRounds - 1{
                notes = true
            }
            for _ in 1 ... gamesPerRound{
                let game = Game()
                let prevGames = currentPrev[numGamesMade - gamesPerRound - 1]
                game.team1 = prevGames.0
                game.team2 = prevGames.1
                game.gameNumber = numGamesMade
                if(round != numRounds)
                {
                    let thisGame = currentNext[numGamesMade - 1]
                    game.winnerGame = thisGame.0
                    game.loserGame = thisGame.1
                }
                newTournament.games.append(game)
                game.time = currentTime[currentLoc]
                game.date = newTournament.date + (Double(currentDate) * TimeInterval(86400))
                currentTime[currentLoc] = currentTime[currentLoc] + newTournament.timeInterval
                if notes {
                    if numTeams == 4 {
                        print(numGamesMade)
                        game.notes = currentNote[numGamesMade - 1]
                    }
                    else if numTeams == 8 {
                        game.notes = currentNote[numGamesMade-5]
                    }
                    else {
                        game.notes = currentNote[numGamesMade - 17]
                    }
                }
                numGamesMade += 1

                game.location = locations[currentLoc]
                if currentGame == gamesPerLoc && currentLoc < newTournament.numLocations - 1{
                    currentLoc += 1
                    currentGame = 0
                }
                currentGame += 1
            }
            //going to the next day
            if currentRoundOfDay == roundsPerDay && currentDate < newTournament.numDays - 1{
                currentDate += 1
                currentRoundOfDay = 0
                currentGame = 1
                currentLoc = 0
                for loc in 0...(newTournament.numLocations - 1){
                    currentTime[loc] = newTournament.firstGame
                }
            }
            currentRoundOfDay += 1
        }
        
    }
    
    func createRoundOneMulti(seed: Int, level: Int, limit: Int){
        
            let levelSum = pwrInt(2, level) + 1
            
            if limit == level + 1
            {
                let game = Game()
                game.team1 = teams[seed - 1]
                game.team2 = teams[levelSum - seed - 1]
                let thisGame = currentNext[numGamesMade - 1]
                game.gameNumber = numGamesMade
                game.winnerGame = thisGame.0
                game.loserGame = thisGame.1
                newTournament.games.append(game)
                numGamesMade += 1
                game.time = currentTime[currentLoc]
                game.date = newTournament.date + (Double(currentDate) * TimeInterval(86400))
                currentTime[currentLoc] = currentTime[currentLoc] + newTournament.timeInterval
                game.location = locations[currentLoc]
                if currentGame == gamesPerLoc && currentLoc < newTournament.numLocations - 1{
                    currentLoc += 1
                    currentGame = 0
                }
                if newTournament.numTeams == 4 {
                    game.notes = "Semi"
                }
                currentGame += 1
                return
            }
            else if seed % 2 == 1
            {
                createRoundOneMulti(seed: seed, level: level + 1, limit: limit);
                createRoundOneMulti(seed: levelSum - seed, level: level + 1, limit: limit);
            }
            else
            {
                createRoundOneMulti(seed: levelSum - seed, level: level + 1, limit: limit)
                createRoundOneMulti(seed: seed, level: level + 1, limit: limit)
            }
        
    }
    
    //https://stackoverflow.com/questions/11245746/league-fixture-generator-in-python/11246261#11246261
    func createRoundRobinTournament (_ numGames: Int)
    {
        teams = newTournament.teams
        var odd = false
        if teams.count % 2 == 1 {
            teams.append("BYE")
            odd = true
        }
        let numTeams = teams.count
        var counter : Double
        counter = Double(numTeams) - 1.0
        if numGames == 3 && !odd
        {
            counter = 3
        }
        else if numGames == 3 || (numGames == 4 && !odd)
        {
            counter = 4
        }
        else if numGames != -1 {
            counter = 5
        }
        roundsPerDay = Int ((counter / Double(newTournament.numDays)) + 0.5)
        let gamesPerRound = Int(numTeams / 2)

        gamesPerLoc = gamesPerRound / newTournament.numLocations
        for _ in 1...Int(counter)
        {
            currentGame = 1
            for i in 0...((numTeams/2) - 1)
            {
                let game = Game()
                let team1 = teams[i]
                let team2 = teams[numTeams - 1 - i]
                if team1 != "BYE" && team2 != "BYE" {
                    game.team1 = team1
                    game.team2 = team2
                    game.gameNumber = numGamesMade
                    newTournament.games.append(game)
                    numGamesMade += 1
                    game.time = currentTime[currentLoc]
                    currentTime[currentLoc] = currentTime[currentLoc] + newTournament.timeInterval
                    game.date = newTournament.date + (Double(currentDate) * TimeInterval(86400))
                    game.location = locations[currentLoc]
                    if currentLoc != locations.count - 1{
                        currentLoc += 1
                    } else {
                        currentLoc = 0
                    }
                    currentGame += 1
                }
            }
            if currentRoundOfDay == roundsPerDay && currentDate < newTournament.numDays - 1{
                currentDate += 1
                currentRoundOfDay = 0
                currentTime[currentLoc] = newTournament.firstGame //make all locs!
                currentGame = 1
                currentLoc = 0
            }
            currentRoundOfDay += 1
            let tempTeam = teams[numTeams - 1]
            teams.remove(at: numTeams - 1)
            teams.insert(tempTeam, at:1)
            
        }
    }
    
    func createSingleEliminationTournament ()
    {
        var numTeams = newTournament.numTeams
        if(numTeams == 5 || numTeams == 9) //one play in game
        {
            let playIn = Game()
            playIn.team1 = teams[numTeams - 1]
            playIn.team2 = teams[numTeams - 2]
            playIn.notes = "Play In"
            playIn.winnerGame = 2
            playIn.gameNumber = numGamesMade
            numGamesMade += 1
            playIn.time = currentTime[currentLoc]
            currentTime[currentLoc] = currentTime[currentLoc] + newTournament.timeInterval
            playIn.date = newTournament.date + (Double(currentDate) * TimeInterval(86400))
            playIn.location = locations[0]
            newTournament.games.append(playIn)
            teams.remove(at: numTeams - 1)
            teams.remove(at:numTeams - 2)
            teams.append("Winner 1")
            winnerFrom += 1
        }
        else if numTeams == 10 || numTeams == 6 { //two play in
            if numTeams == 10 {nextGame = 7.0}
            else {nextGame = 5.0}
            let playIn = Game() //8 vs 9 or 4 vs 5, will play 1
            playIn.team1 = teams[numTeams - 3]
            playIn.team2 = teams[numTeams - 2]
            playIn.notes = "Play In"
            playIn.winnerGame = 3
            playIn.gameNumber = numGamesMade
            numGamesMade += 1
            playIn.time = currentTime[currentLoc]
            currentTime[currentLoc] = currentTime[currentLoc] + newTournament.timeInterval
            playIn.date = newTournament.date + (Double(currentDate) * TimeInterval(86400))
            playIn.location = locations[0]
            newTournament.games.append(playIn)
            let playIn1 = Game() //7 v 10 or 3 vs 6, will play 2
            playIn1.team1 = teams[numTeams - 4]
            playIn1.team2 = teams[numTeams - 1]
            playIn1.notes = "Play In"
            if(numTeams == 10){playIn1.winnerGame = 5}
            else {playIn1.winnerGame = 4}
            playIn1.gameNumber = numGamesMade
            numGamesMade += 1
            if(newTournament.numLocations > 1)
            {
                currentLoc = 1
            }
            playIn1.time = currentTime[currentLoc]
            currentTime[currentLoc] = currentTime[currentLoc] + newTournament.timeInterval
            playIn1.location = locations[currentLoc]
            currentLoc = 0
            playIn1.date = newTournament.date + (Double(currentDate) * TimeInterval(86400))
            newTournament.games.append(playIn1)
            winnerFrom += 2
            if(numTeams == 10) {teams.removeSubrange(6...9)}
            else {teams.removeSubrange(2...5)}
            teams.append("Winner2")
            teams.append("Winner 1")
        }
        else if numTeams == 7{
            teams.append("BYE")
            winnerFrom = 0
            nextGame += 0.5
        }
        else if numTeams == 12{
            nextGame = 5.0
            for x in 0...3 {
                let playIn = Game()
                if x == 0 {
                    playIn.team1 = teams[7]
                    playIn.team2 = teams[8]
                }
                else if x == 1 {
                    playIn.team1 = teams[4]
                    playIn.team2 = teams[11]
                }
                else if x == 2 {
                    playIn.team1 = teams[6]
                    playIn.team2 = teams[9]
                }
                else {
                    playIn.team1 = teams[5]
                    playIn.team2 = teams[10]
                }
                playIn.winnerGame = 5 + x
                playIn.gameNumber = numGamesMade
                numGamesMade += 1
                if(newTournament.numLocations > 1 && x > 1)
                {
                    currentLoc = 1
                }
                playIn.time = currentTime[currentLoc]
                currentTime[currentLoc] = currentTime[currentLoc] + newTournament.timeInterval
                playIn.date = newTournament.date + (Double(currentDate) * TimeInterval(86400))
                playIn.location = locations[currentLoc]
                currentLoc = 0
                newTournament.games.append(playIn)
            }
            winnerFrom += 4
            teams.removeSubrange(4...11)
            teams.append("Winner 4")
            teams.append("Winner 3")
            teams.append("Winner 2")
            teams.append("Winner 1")
            currentRoundOfDay += 1
        }
        

        numTeams = teams.count
        let numRounds = Int(log2(Double(numTeams)))
        roundsPerDay = numRounds / newTournament.numDays
        print("rounds per day: " + String(roundsPerDay))
        createRoundOne (seed: 1, level: 1, limit: numRounds + 1)
        //round one is different because of the teams
        
        //going to the next day
        if currentRoundOfDay == roundsPerDay && currentDate < newTournament.numDays - 1{
            currentDate += 1
            currentRoundOfDay = 0
            for loc in 0...(newTournament.numLocations - 1) {
                currentTime[loc] = newTournament.firstGame
            }
            currentGame = 1
            currentLoc = 0
        }
        
        currentRoundOfDay += 1
        
        for round in 2 ... numRounds
        {
            currentGame = 1
            currentLoc = 0
            let gamesPerRound = numTeams / (pwrInt(2, round))
            createLaterRounds(games: gamesPerRound)
            
            print("rounds per day: " + String(roundsPerDay))
            //going to the next day
            if currentRoundOfDay == roundsPerDay && currentDate < newTournament.numDays - 1{
                currentDate += 1
                currentRoundOfDay = 0
                currentGame = 1
                currentLoc = 0
                for loc in 0...(newTournament.numLocations - 1) {
                    currentTime[loc] = newTournament.firstGame
                }
            }
            currentRoundOfDay += 1
        }
    }
    
    //the structure for the recursion is from this link:
    //https://stackoverflow.com/questions/37199059/generating-a-seeded-tournament-bracket
    func createRoundOne (seed: Int, level: Int, limit: Int)
    {
        gamesPerLoc = (newTournament.numTeams / 2)/newTournament.numLocations
        let levelSum = pwrInt(2, level) + 1
        
        if limit == level + 1
        {
            let game = Game()
            game.team1 = teams[seed - 1]
            game.team2 = teams[levelSum - seed - 1]
            if game.team1 != "BYE" && game.team2 != "BYE"{
                game.gameNumber = numGamesMade
                game.winnerGame = Int(nextGame)
                newTournament.games.append(game)
                numGamesMade += 1
                nextGame += 0.5
                game.time = currentTime[currentLoc]
                game.date = newTournament.date + (Double(currentDate) * TimeInterval(86400))
                currentTime[currentLoc] = currentTime[currentLoc] + newTournament.timeInterval
                if newTournament.numTeams == 4 || newTournament.numTeams == 5 || newTournament.numTeams == 6
                {
                    game.notes = "semi"
                }
                else if newTournament.numTeams == 8 || newTournament.numTeams == 9 || newTournament.numTeams == 10 {
                    game.notes = "qtr final"
                }
            }
            game.location = locations[currentLoc]
            if currentGame == gamesPerLoc && currentLoc < newTournament.numLocations - 1{
                currentLoc += 1
                currentGame = 0
            }
            currentGame += 1
            return
        }
        else if seed % 2 == 1
        {
            createRoundOne(seed: seed, level: level + 1, limit: limit);
            createRoundOne(seed: levelSum - seed, level: level + 1, limit: limit);
        }
        else
        {
            createRoundOne(seed: levelSum - seed, level: level + 1, limit: limit)
            createRoundOne(seed: seed, level: level + 1, limit: limit)
        }
    }
    
    func createLaterRounds(games: Int)
    {
        for _ in 1 ... games
        {
            gamesPerLoc = games/newTournament.numLocations
            let game = Game()
            game.gameNumber = numGamesMade
            numGamesMade += 1
            if(games != 1) //the championship round does not have a next game!!
            {
                game.winnerGame = Int(nextGame)
                nextGame += 0.5
            }
            if(newTournament.numTeams == 7 && winnerFrom == 0)
            {
                game.team1 = newTournament.teams[0]
                game.team2 = "Winner 1"
                winnerFrom += 2
            }
            else{
                game.team1 = "Winner " + String(Int(winnerFrom))
                game.team2 = "Winner " + String(Int(winnerFrom + 1))
                winnerFrom += 2
            }
            game.time = currentTime[currentLoc]
            currentTime[currentLoc] = currentTime[currentLoc] + newTournament.timeInterval
            game.date = newTournament.date + (Double(currentDate) * TimeInterval(86400))
            game.location = locations[currentLoc]
            if currentGame == gamesPerLoc && currentLoc < newTournament.numLocations - 1{
                currentLoc += 1
                currentGame = 0
            }
            currentGame += 1
            if(games == 1)
            {
                game.notes = "1st place game"
            }
            else if (games == 2)
            {
                game.notes = "semi"
            }
            else if games == 4{
                game.notes = "qtr final"
            }
            newTournament.games.append(game)
        }
    }
    
    //https://stackoverflow.com/questions/24196689/how-to-get-the-power-of-some-integer-in-swift-language
    let pwrInt:(Int,Int)->Int = { a,b in return Int(pow(Double(a),Double(b))) }
}
