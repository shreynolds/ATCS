//
//  Game.swift
//  Tournaments
//
//  Created by Sophie Reynolds on 3/1/19.
//  Copyright © 2019 Sophie Reynolds. All rights reserved.
//

import Foundation

class Game: NSObject {
    var team1 = "BYE"
    var team2 = "BYE"
    var score1 = 0.0
    var score2 = 0.0
    var winnerGame = 0
    var loserGame = 0
    var gameNumber = 0
    var time = Date()
    var date = Date()
    var notes = ""
    var location = ""
}
