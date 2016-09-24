//
//  TeamDownloader.swift
//  SandSports
//
//  Created by Carl Kenne on 27/05/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import Foundation
import UIKit

class GamesDownloader {
    
    func downloadHTML(team:Team, callback:([GamesTableSection]) -> Void) {
        
        HttpDownloader().httpGetOld("http://sandsportsoz.com/" + team.id){
            (data, error) -> Void in
            if error != nil {
                println(error)
            } else {
                var results = self.parseHTML(data!, teamName:team.name)
                var sections = self.createSections(results)
                callback(sections)
            }
        }
    }
    
    func parseHTML(HTMLData:NSData, teamName: String) ->[Game] {
        var error: NSError?
        var error2: NSErrorPointer? = nil
        var games = [Game]()
        
        let parser = TFHpple(HTMLData: HTMLData)
        var pairingsResults = parser.searchWithXPathQuery("//table[@class='fixtureTBL']/tr/td[position()=1 or position()=4 or position()=3 or position()=2 or position()=6]")
        
        if let error = error {
            println("Error : \(error)")
        } else {
            for var i = ((pairingsResults.count - 4) / 5)-1; i >= 0 ; i--
            {
                
                var startAt = (i * 5) + 5
                var dates:NSString = (pairingsResults[startAt] as TFHppleElement).content.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                
                var time:NSString = "";
                if((pairingsResults[startAt + 1]  as TFHppleElement).content != "B")
                {
                time = " @ " + (pairingsResults[startAt + 1] as TFHppleElement).content.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) +
                "pm \n"
                }
                
                var score = (pairingsResults[startAt + 4] as TFHppleElement).content.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                
                if(score == "X") {
                    score = ""
                }
                
                var vsTeam = (pairingsResults[startAt + 2] as TFHppleElement).content.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                
                if(vsTeam == teamName){
                    vsTeam = (pairingsResults[startAt + 3] as TFHppleElement).content.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                } else if(score != ""){
                    //since we are taking the first team and putting it last, we also need to take the first score and put it last
                    var s1 = score.componentsSeparatedByString("-")[0]
                    var s2 = score.componentsSeparatedByString("-")[1]
                    score = s2 + "-" + s1
                }
                
                let game = Game(score:score, vsTeam:vsTeam, date:dates + time)
                games.append(game)
            }
        }
        
        return games
    }
    
    func createSections(games:[Game]) -> [GamesTableSection]{
        
        var results = [GamesTableSection]()
        var pastGames = GamesTableSection(title:"past games", contents:[NSMutableAttributedString]())
        var upcomingGames = GamesTableSection(title:"upcoming games", contents:[NSMutableAttributedString]())
        
        for var i = 0; i < games.count ; i++
        {
            let game = games[i]
            var subtext:NSString = ""
            
            if(game.vsTeam != "Bye"){
                subtext = "vs. " + game.vsTeam + " " + game.score
            } else {
                subtext = "Bye"
            }
            
            var attriString:NSMutableAttributedString = NSMutableAttributedString(string: game.date + " " + subtext)
            
            attriString.addAttributes([NSFontAttributeName:UIFont.boldSystemFontOfSize(14)], range: NSRange(location:0, length:game.date.length))
            
            attriString.addAttributes([NSFontAttributeName:UIFont.boldSystemFontOfSize(14)], range: NSRange(location:0, length:game.date.length))
            attriString.addAttributes([NSFontAttributeName:UIFont.systemFontOfSize(14)], range: NSRange(location:game.date.length+1, length:subtext.length))
            
            if(game.score == "" && game.vsTeam != "Bye" && game.vsTeam != ""){
                upcomingGames.contents.append(attriString)
            } else {
                pastGames.contents.append(attriString)
            }
        }
        
        if(upcomingGames.contents.count > 0){
            results.append(upcomingGames)
        }
        
        if(pastGames.contents.count > 0){
            results.append(pastGames)
        }
        
        return results
    }
}
