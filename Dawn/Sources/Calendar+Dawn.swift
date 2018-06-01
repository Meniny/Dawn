//
//  Calendar+Dawn.swift
//  Dawn
//
//  Copyright 2015 Meniny
//

import Foundation

public extension Calendar {
    public func date(year: Int = 1970, month: Int = 1, day: Int = 1, hour: Int = 0, minute: Int = 0, second: Int = 0) -> Date {
        var components = DateComponents()
        
        components.year   = year
        components.month  = month
        components.day    = day
        components.hour   = hour
        components.minute = minute
        components.second = second
        
        return self.date(from: components)!
    }
    
    public enum DateCalculatingOperationType {
        case adding, subtracting
    }
    
    public func date(by calculating: TimeCalculatingOperation, _ value: Int, of type: TimePeriodSize, to date: Date) -> Date? {
        let newValue = (calculating == .adding) ? value : -value
        var components = DateComponents()
        switch type {
        case .year:
            components.year = newValue
            break
        case .month:
            components.month = newValue
            break
        case .day:
            components.day = newValue
            break
        case .week:
            components.weekOfYear = newValue
            break
        case .hour:
            components.hour = newValue
            break
        case .minute:
            components.minute = newValue
            break
        default:
            components.second = newValue
            break
        }
        return self.date(byAdding: components, to: date)
    }
    
    // MARK: - Adding components to dates
    public func date(byAdding value: Int, of type: TimePeriodSize, to date: Date) -> Date? {
        return self.date(by: .adding, value, of: type, to: date)
    }
    
    public func dateByAdding(years: Int, to date: Date) -> Date? {
        return self.date(byAdding: years, of: .year, to: date)
    }
    
    public func dateByAdding(months: Int, to date: Date) -> Date? {
        return self.date(byAdding: months, of: .month, to: date)
    }
    
    public func dateByAdding(weeks: Int, to date: Date) -> Date? {
        return self.date(byAdding: weeks, of: .week, to: date)
    }
    
    public func dateByAdding(days: Int, to date: Date) -> Date? {
        return self.date(byAdding: days, of: .day, to: date)
    }
    
    public func dateByAdding(hours: Int, to date: Date) -> Date? {
        return self.date(byAdding: hours, of: .hour, to: date)
    }
    
    public func dateByAdding(minutes: Int, to date: Date) -> Date? {
        return self.date(byAdding: minutes, of: .minute, to: date)
    }
    
    public func dateByAdding(seconds: Int, to date: Date) -> Date? {
        return self.date(byAdding: seconds, of: .second, to: date)
    }
    
    // MARK: - Subtracting components from dates
    public func date(bySubtracting value: Int, of type: TimePeriodSize, to date: Date) -> Date? {
        return self.date(by: .subtracting, value, of: type, to: date)
    }
    
    public func dateBySubtracting(years: Int, from date: Date) -> Date? {
        return self.date(bySubtracting: years, of: .year, to: date)
    }
    
    public func dateBySubtracting(months: Int, from date: Date) -> Date? {
        return self.date(bySubtracting: months, of: .month, to: date)
    }
    
    public func dateBySubtracting(weeks: Int, from date: Date) -> Date? {
        return self.date(bySubtracting: weeks, of: .week, to: date)
    }
    
    public func dateBySubtracting(days: Int, from date: Date) -> Date? {
        return self.date(bySubtracting: days, of: .day, to: date)
    }
    
    public func dateBySubtracting(hours: Int, from date: Date) -> Date? {
        return self.date(bySubtracting: hours, of: .hour, to: date)
    }
    
    public func dateBySubtracting(minutes: Int, from date: Date) -> Date? {
        return self.date(bySubtracting: minutes, of: .minute, to: date)
    }
    
    public func dateBySubtracting(seconds: Int, from date: Date) -> Date? {
        return self.date(bySubtracting: seconds, of: .second, to: date)
    }
    
    // MARK: - Counting components between dates
    
    public func counting(_ expected: DateCountingUnit, from firstDate: Date, to secondDate: Date) -> Int? {
        let earliest = (firstDate < secondDate) ? firstDate : secondDate
        let latest = (firstDate == earliest) ? secondDate : firstDate
        
        let multiplier = (earliest == firstDate) ? -1 : 1
        let components = self.dateComponents(expected.components, from: earliest, to: latest)
        
        switch expected {
        case .years:
            if let year = components.year {
                return multiplier * year
            }
            break
        case .months:
            if let year = components.year, let month = components.month {
                return multiplier * (month + 12 * year)
            }
            break
        case .weeks:
            if let week = components.weekOfYear {
                return multiplier * week
            }
            break
        default:
            if let day = components.day {
                return multiplier * day
            }
            break
        }
        return nil
    }
    
    public func years(from firstDate: Date, to secondDate: Date) -> Int? {
        return self.counting(.years, from: firstDate, to: secondDate)
    }
    
    public func months(from firstDate: Date, to secondDate: Date) -> Int? {
        return self.counting(.months, from: firstDate, to: secondDate)
    }
    
    public func weeks(from firstDate: Date, to secondDate: Date) -> Int? {
        return self.counting(.weeks, from: firstDate, to: secondDate)
    }
    
    public func days(from firstDate: Date, to secondDate: Date) -> Int? {
        return self.counting(.days, from: firstDate, to: secondDate)
    }
    
    //MARK: - Counting how much earlier one date is than another
    public func yearsEarlier(_ firstDate: Date, than secondDate: Date) -> Int? {
        if let distance = self.years(from: firstDate, to: secondDate) {
            return abs(min(distance, 0))
        }
        return nil
    }
    
    public func monthsEarlier(_ firstDate: Date, than secondDate: Date) -> Int? {
        return abs(min(self.months(from: firstDate, to: secondDate) ?? 0, 0))
    }
    
    public func weeksEarlier(_ firstDate: Date, than secondDate: Date) -> Int? {
        return abs(min(self.weeks(from: firstDate, to: secondDate) ?? 0, 0))
    }
    
    public func daysEarlier(_ firstDate: Date, than secondDate: Date) -> Int? {
        return abs(min(self.days(from: firstDate, to: secondDate) ?? 0, 0))
    }
    
    public func hoursEarlier(_ firstDate: Date, than secondDate: Date) -> Double? {
        return abs(min(firstDate.hours(from: secondDate), 0))
    }
    
    public func minutesEarlier(_ firstDate: Date, than secondDate: Date) -> Double? {
        return abs(min(firstDate.minutes(from: secondDate), 0))
    }
    
    public func secondsEarlier(_ firstDate: Date, than secondDate: Date) -> Double? {
        return abs(min(firstDate.seconds(from: secondDate), 0))
    }
    
    public static func isLeapYear(year: Int) -> Bool {
        return (year % 400 == 0) || ((year % 4 == 0) && (year % 100 != 0))
    }
}
