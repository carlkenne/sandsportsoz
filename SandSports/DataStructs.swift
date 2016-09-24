//
//  DataObjects.swift
//  SandSports
//
//  Created by Carl Kenne on 27/05/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import Foundation

struct Team {
    let name:String
    let id:String
}

// A, B, C, D, E...
struct TeamsTableSection {
    let name:String
    let teams:[Team]
}

struct Game{
    let score:String
    let vsTeam:String
    let date:NSString
}

// played / upcoming games
struct GamesTableSection {
    let title: String
    var contents: [NSMutableAttributedString]
}