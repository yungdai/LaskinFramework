//
//  DateUtilities.swift
//  EMobileView
//
//  Created by Yung Dai on 2016-11-29.
//  Copyright © 2016 Yung Dai. All rights reserved.
//

import UIKit

extension NSDate {
    
    func getDateOfWeek(_ date: NSDate) -> String {

        let calendar = NSCalendar.current
        
        let dayOfWeek = calendar.component(.weekday, from: date as Date)
        let month = calendar.component(.month, from: date as Date)
        let day = calendar.component(.day, from: date as Date)

        let dayString = String.getDayOfWeekAsString(dayOfWeek)!
        let monthString = String.getMonthAsString(month)!

        return "\(dayString), \(monthString) \(day)"
    }
}
