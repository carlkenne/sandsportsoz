//
//  TeamsDownloader.swift
//  SandSports
//
//  Created by Carl Kenne on 27/05/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import Foundation
import UIKit

class TeamsDownloader {
    func downloadHTML(callback:([Team]) -> Void) {
        HttpDownloader().httpGetOld("http://sandsportsoz.com/team.php"){
            (data, error) -> Void in
            if error != nil {
                print(error)
            } else {
                var results = self.parseHTML(data!)
                callback(results)
            }
        }
    }
    
    func parseHTML(HTMLData:NSData) -> [Team] {
        var error: NSError?
        let parser = TFHpple(HTMLData: HTMLData)
        var teamResults = parser.searchWithXPathQuery("//div[@class='teamName']/a")
        var idResults = parser.searchWithXPathQuery("//div[@class='teamName']/a/@href")
        var teams = [Team]()
        if let error = error {
            print("Error : \(error)")
        } else {
            for var i = teamResults.count-1; i >= 0 ; i -= 1
            {
                var name:NSString = (teamResults[i] as! TFHppleElement).content.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                var id:NSString = (idResults[i] as! TFHppleElement).content.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
                
                teams.append(Team(name:name as String, id: id as String))
            }
        }
        teams.sortInPlace({ $0.name < $1.name })
        return teams
    }
}