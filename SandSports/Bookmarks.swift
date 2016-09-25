//
//  Bookmarks.swift
//  SandSports
//
//  Created by Carl Kenne on 12/05/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import Foundation

import UIKit

class Bookmarks: UITableViewController {
    
    var bookmarks = [Team]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        let image = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("smallerBg", ofType: "png")!)
        image?.drawInRect(self.view.bounds)
        let i = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        view.backgroundColor = UIColor(patternImage: i)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("ShowTeam", sender: self)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        return bookmarks.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = (self.view as! UITableView).dequeueReusableCellWithIdentifier("Team")! as UITableViewCell
        let team = bookmarks[indexPath.row]
        cell.textLabel!.text = team.name
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "ShowTeam" {
            let teamDetailViewController = segue.destinationViewController as! TeamViewController
            
            let indexPath = (view as! UITableView).indexPathForSelectedRow!
            let team = self.bookmarks[indexPath.row]
            teamDetailViewController.title = team.name
            teamDetailViewController.team = team
            teamDetailViewController.showTeam()
        }
    }
}