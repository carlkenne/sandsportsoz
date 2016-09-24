//
//  ViewController.swift
//  SandSports
//
//  Created by Carl Kenne on 21/02/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import UIKit
import Foundation

class TeamViewController: UIViewController {

    @IBOutlet var totalTextField : UITextField!
    @IBOutlet var resultsTableView : UITableView!
    @IBOutlet var loading : UIActivityIndicatorView!
    var team: Team = Team(name:"",id:"");
    var loaded:Bool = false
    var gamesDataSource = GamesDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        resultsTableView.dataSource = gamesDataSource
        resultsTableView.delegate = gamesDataSource
        resultsTableView.hidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        var image = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("smallerBg", ofType: "png")!)
        image?.drawInRect(self.view.bounds)
        var i = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        view.backgroundColor = UIColor(patternImage: i)
        loaded = true
        
        if(team.id != ""){
            showTeam()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return UIInterfaceOrientation.Portrait.rawValue
    }
    
    func showTeam(){
        if(loaded == true) {
            loading.startAnimating()
            resultsTableView.reloadData()
            resultsTableView.hidden = true
            
            gamesDataSource.clear()
            GamesDownloader().downloadHTML(team){
                (res) -> Void in
                self.gamesDataSource.set(res)
                self.resultsTableView.hidden = false
                self.loading.stopAnimating()
                self.resultsTableView.reloadData()
            }
        }
    }
}


class GamesDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
        
        var results = [GamesTableSection]()
        
    
        func set(cells:[GamesTableSection]){
            results = cells
        }
    
        func clear(){
            results = [GamesTableSection]()
        }
    
        func tableView(UITableView, numberOfRowsInSection: Int) -> Int {
            return results[numberOfRowsInSection].contents.count
        }
        
        func tableView(UITableView, cellForRowAtIndexPath: NSIndexPath) -> UITableViewCell{
            var cell = UITableViewCell()
            cell.textLabel?.attributedText = results[cellForRowAtIndexPath.section].contents[cellForRowAtIndexPath.row]
            cell.textLabel?.numberOfLines = 3
            cell.backgroundColor = UIColor(red: 256, green: 256, blue: 256, alpha: 0.50)
            return cell
        }
        
        func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
            if let view = view as? UITableViewHeaderFooterView {
                view.textLabel.backgroundColor = UIColor.clearColor()
                view.textLabel.textColor = UIColor.blackColor()
            }
        }
        
        func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            return results[section].title
        }
        
        func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return results.count;
        }
    }

