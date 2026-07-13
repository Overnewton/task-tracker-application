//
//  Untitled.swift
//  Task Tracker Application
//
//  Created by Kaelan Just on 22/6/2026.
//

import Foundation
import UIKit

///Date Class
struct ProgramDate: CustomStringConvertible, Equatable, Comparable, Codable, Hashable {
    //automatically makes print statements and string interpolation work
    var description: String {
        "\(self.standardDate().day)/\(self.standardDate().month)/\(self.standardDate().year)"
    }
    
    static var today: ProgramDate {
        let now = Date()
        let calendar = Calendar.current
        
        let day = UInt(calendar.component(.day, from: now))
        let month = UInt(calendar.component(.month, from: now))
        let year = UInt(calendar.component(.year, from: now))
        return ProgramDate(day: day, month: month, year: year)
    }
    
    //orders the dates by their value
    static func < (lhs: ProgramDate, rhs: ProgramDate) -> Bool {
        return lhs.daysSinceFirst < rhs.daysSinceFirst
    }
    
    //first storable date corresponds with Sunday Jan 1st 1967
    var daysSinceFirst: UInt
    
    
    ///gets if the specific year is a leap year
    static func isLeap(_ year: UInt) -> Bool {
        (year % 400 == 0) || ((year % 4 == 0) && (year % 100 != 0))
    }
    
    
    //let statements to get month lengths to use in function
    static let monthLengthsCommon: [UInt] = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    static let monthLengthsLeap: [UInt] = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    
    init(daysSinceFirst: UInt) {
        self.daysSinceFirst = daysSinceFirst
    }
    
    init(month: UInt) {
        self.daysSinceFirst = ProgramDate(day: 1, month: month % 12 + 1, year: (month / 12) + 1967).daysSinceFirst
    }
    
    init(day: UInt, month: UInt, year: UInt) {
        
        //initialises the 'days' variable
        var days: UInt = 0
        
        ///sets the first year to account for, 1967 was chosen due to it being before unix epoch and also being a sunday. can be changed later without messing up code if needed
        var y: UInt = 1967
        //loops over each year between the first year and the target year (including the first year but excluding the target year)
        while y < year {
            //increments days variable by the number of days in that year
            days += ProgramDate.isLeap(y) ? 366 : 365
            y += 1
        }
        //sets the list of months
        let months = ProgramDate.isLeap(year) ? ProgramDate.monthLengthsLeap : ProgramDate.monthLengthsCommon
        //loops over required months
        for m in 0..<Int(month) {
            //increments days variable by the number of days in that month
            days += months[m]
        }
        //adds the input day of the month to the days variable
        days += day
        daysSinceFirst = days
    }
    
    func standardDate() -> (day: UInt, month: UInt, year: UInt) {
        
        //initialises the 'remaining' variable
        var remaining = daysSinceFirst
        
        ///sets the first year to account for, 1967 was chosen due to it being before unix epoch and also being a sunday. can be changed later without messing up code if needed
        var year: UInt = 1967
        
        //loops until the number of days cannot be subdivided into years
        while true {
            //gets year length
            let yearLength: UInt = ProgramDate.isLeap(year) ? 366 : 365
            //checks if the number of days remaining fits into the year length and breaks out of the loop if not
            if remaining < yearLength { break }
            //decrements the number of days remaining by the length of the year and then increments the year
            remaining -= yearLength
            year += 1
        }
        //gets the days of each month in the year
        let months = ProgramDate.isLeap(year) ? ProgramDate.monthLengthsLeap : ProgramDate.monthLengthsCommon
        var month: UInt = 0
        //loops until the number of days cannot be subdivided into months
        while remaining >= months[Int(month)] {
            //decrements the number of days remaining by the length of the month and then increments the month
            remaining -= months[Int(month)]
            month += 1
        }
        //sets the day as the number of days remaining
        let day = remaining
        //returns date in dd/mm/yyyy ordering
        return(day,month,year)
    }
    
    func nextDay() -> ProgramDate {
        return ProgramDate(daysSinceFirst: self.daysSinceFirst + 1)
    }
    
    enum daysOfTheWeek {
        case Monday
        case Tuesday
        case Wednesday
        case Thursday
        case Friday
        case Saturday
        case Sunday
        init(_ daysSinceSunday: UInt) {
            switch daysSinceSunday%7 {
            case 0:
                self = .Sunday
            case 1:
                self = .Monday
            case 2:
                self = .Tuesday
            case 3:
                self = .Wednesday
            case 4:
                self = .Thursday
            case 5:
                self = .Friday
            case 6:
                self = .Saturday
            default:
                self = .Sunday
            }
        }
    }
}

///Color Class
struct ColourCodable: Codable {
    //this class exists to allow for storing colours in the file
    var red: CGFloat
    var green: CGFloat
    var blue: CGFloat
    var alpha: CGFloat
    
    func UIColor() -> UIColor {
        UIKit.UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    init(from color: UIColor) {
        self.red = color.cgColor.components?[0] ?? 0
        self.green = color.cgColor.components?[1] ?? 0
        self.blue = color.cgColor.components?[2] ?? 0
        self.alpha = color.cgColor.components?[3] ?? 0
    }
}

struct Task: Codable {
    var dueDate: Date
    var title: String
    var description: String
    var colour: ColourCodable
    var properties: [String]
}
