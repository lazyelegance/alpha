//
//  AlphaGenerics.swift
//  alpha
//
//  Created by Ezra Bathini on 27/08/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import Foundation


let categoryFont = UIFont.boldSystemFont(ofSize: 10) 

public func calculateDateValues() -> (Date, String, String) {
    let timzoneSeconds = NSTimeZone.local.secondsFromGMT()
    
    let currDate = Date().addingTimeInterval(Double(timzoneSeconds))
    
    let formatter_mon = DateFormatter()
    formatter_mon.dateFormat = "MMMM_yyyy"
    let currmon = "m_" + formatter_mon.string(from: currDate)
    
    
    
    let formatter_week = DateFormatter()
    formatter_week.dateFormat = "w_yyyy"
    let currweek = "w_" + formatter_week.string(from: currDate)
    
    return (currDate, currmon, currweek)
}

public func calculateDateValuesMore() -> (Date, String, String, String, String) {
    let timzoneSeconds = NSTimeZone.local.secondsFromGMT()
    
    let currDate = Date().addingTimeInterval(Double(timzoneSeconds))
    
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM"
    let mon = formatter.string(from: currDate)
    
    formatter.dateFormat = "w"
    let week = formatter.string(from: currDate)
    
    formatter.dateFormat = "d"
    let day = formatter.string(from: currDate)
    
    formatter.dateFormat = "yyyy"
    let year = formatter.string(from: currDate)
    
    
    
    return (currDate, day, mon, year, week)
}


public enum SegmentButtonState {
    case total
    case thisMonth
    case thisWeek
    
    func titleString() -> String {
        switch self {
        case .total:
            return "Total".uppercased()
        case .thisMonth:
            return "This Month".uppercased()
        case .thisWeek:
            return "This Week".uppercased()
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
