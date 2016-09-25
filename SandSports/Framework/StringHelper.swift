//
//  StringHelper.swift
//  SandSports
//
//  Created by Carl Kenne on 27/05/15.
//  Copyright (c) 2015 Carl Kenne. All rights reserved.
//

import Foundation

extension String {
    
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    /*subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: self.startIndex.advanceBy(r.startIndex), end: self.startIndex.advanceBy(r.endIndex)))
    }*/
}

class Date {
    
    class func from(year:Int, month:Int, day:Int) -> NSDate {
        let c = NSDateComponents()
        c.year = year
        c.month = month
        c.day = day
        
        let gregorian = NSCalendar(identifier:NSGregorianCalendar)
        let date = gregorian?.dateFromComponents(c)
        return date!
    }
    
    class func parse(dateStr:String, format:String="yyyy.MM.dd") -> NSDate {
        let dateFmt = NSDateFormatter()
        dateFmt.timeZone = NSTimeZone.defaultTimeZone()
        dateFmt.dateFormat = format
        return dateFmt.dateFromString(dateStr)!
    }
}