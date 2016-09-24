//
//  HttpDownloader.swift
//  SandSports
//
//  Created by Carl Kenne on 27/05/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import Foundation

class HttpDownloader{
    func httpGetOld(request1: String, callback: (NSData?, String?) -> Void){

        var request = NSMutableURLRequest(URL: NSURL(string: request1)!)
        
    /*    var cookies:[NSHTTPCookie] = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies as [NSHTTPCookie]
        
        println("cookies: \(cookies.count)")
        
        for cookie:NSHTTPCookie in cookies as [NSHTTPCookie] {
            if(cookie.name == "PHPSESSID"){
                var cookieValue : String = "PHPSESSID=" + cookie.value! as String
                request.HTTPShouldHandleCookies = false
                request.setValue(cookieValue, forHTTPHeaderField: "cookie")
                println("cookie set \(cookieValue)")
            }
        }*/
        
        let queue:NSOperationQueue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            dispatch_async(dispatch_get_main_queue()) {
                if error != nil {
                    callback(nil, error.localizedDescription)
                } else {
                    callback(data, nil)
                }
            }
        })
    }
}