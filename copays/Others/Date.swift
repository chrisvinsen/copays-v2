//
//  Date.swift
//  copays
//
//  Created by Christianto Vinsen on 07/04/22.
//x

import Foundation

class CDate {

    class func from(year: Int, month: Int, day: Int) -> Date {
        let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian)!

        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day

        let date = gregorianCalendar.date(from: dateComponents)!
        return date
    }

    class func parse(_ string: String, format: String = "yyyy-MM-dd") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.default
        dateFormatter.dateFormat = format

        let date = dateFormatter.date(from: string)!
        return date
    }
    
    class func toDateString(_ date: Date, format: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = format

        // Convert Date to String
        return dateFormatter.string(from: date)
    }
}
