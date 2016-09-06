//
//  AlphaGenerics.swift
//  alpha
//
//  Created by Ezra Bathini on 27/08/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import Foundation
import Material


let categoryFont = RobotoFont.mediumWithSize(10)

public func calculateDateValues() -> (NSDate, String, String) {
    let timzoneSeconds = NSTimeZone.localTimeZone().secondsFromGMT
    
    let currDate = NSDate().dateByAddingTimeInterval(Double(timzoneSeconds))
    
    let formatter_mon = NSDateFormatter()
    formatter_mon.dateFormat = "MMMM_yyyy"
    let currmon = "m_" + formatter_mon.stringFromDate(currDate)
    
    
    
    let formatter_week = NSDateFormatter()
    formatter_week.dateFormat = "w_yyyy"
    let currweek = "w_" + formatter_week.stringFromDate(currDate)
    
    return (currDate, currmon, currweek)
}

public func calculateDateValuesMore() -> (NSDate, String, String, String, String) {
    let timzoneSeconds = NSTimeZone.localTimeZone().secondsFromGMT
    
    let currDate = NSDate().dateByAddingTimeInterval(Double(timzoneSeconds))
    
    let formatter = NSDateFormatter()
    formatter.dateFormat = "MMMM"
    let mon = formatter.stringFromDate(currDate)
    
    formatter.dateFormat = "w"
    let week = formatter.stringFromDate(currDate)
    
    formatter.dateFormat = "d"
    let day = formatter.stringFromDate(currDate)
    
    formatter.dateFormat = "yyyy"
    let year = formatter.stringFromDate(currDate)
    
    
    
    return (currDate, day, mon, year, week)
}


public enum SegmentButtonState {
    case total
    case thisMonth
    case thisWeek
    
    func titleString() -> String {
        switch self {
        case .total:
            return "Total".uppercaseString
        case .thisMonth:
            return "This Month".uppercaseString
        case .thisWeek:
            return "This Week".uppercaseString
        }
    }
    
    func nextState() -> SegmentButtonState {
        switch self {
        case .total:
            return .thisMonth
        case .thisMonth:
            return .thisWeek
        case .thisWeek:
            return .total
        }
    }
    
}