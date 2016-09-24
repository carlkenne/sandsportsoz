//
//  ViewControllerBookmarksViewController.swift
//  SandSports
//
//  Created by Carl Kenne on 28/04/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import UIKit

class ViewControllerBookmarksViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UIGraphicsBeginImageContext(self.view.frame.size)
        var image = UIImage(contentsOfFile: NSBundle.mainBundle().pathForResource("smallerBg", ofType: "png")!)
        image?.drawInRect(self.view.bounds)
        var i = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        view.backgroundColor = UIColor(patternImage: i)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
