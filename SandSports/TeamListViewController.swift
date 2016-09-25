//
//  ViewControllerNavigation.swift
//  SandSports
//
//  Created by Carl Kenne on 30/04/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import UIKit

class TeamListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate {

    var results = [TeamsTableSection]()
    var allResults = [Team]()
    var filteredResults = [Team]()
    var bookmarks = [Team]()
    
    @IBOutlet var resultsTableView : UITableView!
    @IBOutlet var search : UISearchDisplayController!
    @IBOutlet var loading : UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchDisplayController?.delegate = self
        UIGraphicsBeginImageContext(self.view.frame.size)
        var image = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("smallerBg", ofType: "png")!)
        image?.drawInRect(self.view.bounds)
        var i = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        view.backgroundColor = UIColor(patternImage: i)
        
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
        loading.startAnimating()
        
        TeamsDownloader().downloadHTML(){(teams) -> Void in
            
            let sectionNames = NSSet(array: teams.map {
                return self.getSectionNameFrom($0.name)
            }).allObjects
            
             self.results = sectionNames.map {
                let sectionName:String = $0 as! String
                
                return TeamsTableSection(name: sectionName, teams: teams.filter( {(team: Team) -> Bool in
                        self.getSectionNameFrom(team.name) == sectionName
                    }))
            }
            
            self.allResults = teams
            self.loading.stopAnimating()
            self.resultsTableView.reloadData()
        }
    }
    
    func getSectionNameFrom(name:String) -> String {
        for i in 0 ..< name.characters.count {
            if("abcdefghijklmnopqrstuvwxyz".rangeOfString(name[i].lowercaseString) != nil){
                return name[i]
            }
        }
        
        return "#"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("ShowTeam", sender: self)
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection: Int) -> Int {
        if tableView == search.searchResultsTableView {
            return filteredResults.count
        } else {
            return results[numberOfRowsInSection].teams.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = resultsTableView.dequeueReusableCellWithIdentifier("Team")! as UITableViewCell
        
        var team : Team
        if tableView == search.searchResultsTableView {
            if(indexPath.row < filteredResults.count){
                team = filteredResults[indexPath.row]
            } else {
                team = Team(name: "\(indexPath.row) \(indexPath.section)", id: "673")
            }
            
            
        } else {
            team = results[indexPath.section].teams[indexPath.row]
        }

        // Configure the cell
        cell.textLabel!.text = team.name
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        let v = UIView()
        v.backgroundColor = UIColor(red: 111, green: 209, blue: 237, alpha: 0.6)
        cell.selectedBackgroundView = v;

        
        return cell
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [.Portrait, .PortraitUpsideDown]
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if tableView == search.searchResultsTableView {
            return 1
        } else {
            return results.count;
        }
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        if let view = view as? UITableViewHeaderFooterView {
            view.textLabel!.backgroundColor = UIColor.clearColor()
            view.textLabel!.textColor = UIColor.blackColor()
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if search.searchResultsTableView == tableView {
            return ""
        } else {
            return results[section].name
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "ShowTeam" {
            let teamDetailViewController = segue.destinationViewController as! TeamViewController
            var team:Team
            if search.active {
                let indexPath = self.search!.searchResultsTableView.indexPathForSelectedRow!
                team = self.filteredResults[indexPath.row]
            } else {
                let indexPath = resultsTableView.indexPathForSelectedRow!
                team = self.results[indexPath.section].teams[indexPath.row]
            }
            
            if bookmarks.filter({(t : Team) -> Bool in return t.name == team.name }).count == 0 {
                bookmarks.append(team)
            }
            if(bookmarks.count > 5){
                bookmarks.removeAtIndex(0)
            }
            
            teamDetailViewController.title = team.name
            teamDetailViewController.team = team
            teamDetailViewController.showTeam()
        }
        if segue.identifier == "ShowBookmarks" {
            let controller = segue.destinationViewController as! Bookmarks
            controller.bookmarks = bookmarks
        }
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        self.filteredResults = self.allResults.filter({( team : Team) -> Bool in
            let stringMatch = team.name.lowercaseString.rangeOfString(searchText.lowercaseString)
            return (stringMatch != nil)
        })
    }
    
    func searchDisplayController(controller: UISearchDisplayController?!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController,
        shouldReloadTableForSearchScope searchOption: Int) -> Bool {
            self.filterContentForSearchText(self.searchDisplayController!.searchBar.text!)
            return true
    }
    
    func searchBarBookmarkButtonClicked(searchBar: UISearchBar) {
        self.performSegueWithIdentifier("ShowBookmarks", sender: self)
    }
}


