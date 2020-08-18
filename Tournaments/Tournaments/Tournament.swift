//
//  Tournament.swift
//  Tournaments
//
//  Created by Sophie Reynolds on 2/26/19.
//  Copyright © 2019 Sophie Reynolds. All rights reserved.
//

import Foundation

class Tournament:NSObject {
    var numTeams = 0
    var name = "NOT MADE YET"
    var games = [Game]()
    var teams = [String]()
    var type = "Single Elimination"
    var numDays = 1
    var numLocations = 1
    var locations = [String]()
    
    var gamesDone = 0
    
    
    var date: Date!
    var timeInterval: TimeInterval!
    var firstGame: Date!
}
