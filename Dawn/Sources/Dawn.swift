//
//  Dawn.swift
//  Pods
//
//  Created by Meniny on 2017-08-01.
//
//

import Foundation

public struct Dawn {
    
    public static var calendar: Calendar = Calendar.current
    
    public var calendar: Calendar
    public init(calendar c: Calendar) {
        calendar = c
    }
    
    // MARK: - Leap Year
    
    public static func checkLeapYear(_ year: Int) -> Bool {
        return (year % 400 == 0) || ((year % 4 == 0) && (year % 100 != 0))
    }
    
    public func checkLeapYear(_ year: Int) -> Bool {
        return Dawn.checkLeapYear(year)
    }
    
    // MARK: - Compare
    
    // Class
    
    public static func compare(date: Date, ifEarlier another: Date) -> Bool {
        return date.isEarlier(than: another)
    }
    
    public static func compare(date: Date, ifEarlierThanOrEqualTo another: Date) -> Bool {
        return date.isEarlierThanOrEqualTo(another)
    }
    
    public static func compare(date: Date, ifLater another: Date) -> Bool {
        return date.isLater(than: another)
    }
    
    public static func compare(date: Date, ifLaterThanOrEqualTo another: Date) -> Bool {
        return date.isLaterThanOrEqualTo(another)
    }
    
    public static func compare(date: Date, ifEqualTo another: Date) -> Bool {
        return date.isEqualTo(another)
    }
    
    public static func compare(date: Date, ifNotEqualTo another: Date) -> Bool {
        return !date.isEqualTo(another)
    }
    
    // Instance
    
    public func compare(date: Date, ifEarlier another: Date) -> Bool {
        return date.isEarlier(than: another)
    }
    
    public func compare(date: Date, ifEarlierThanOrEqualTo another: Date) -> Bool {
        return date.isEarlierThanOrEqualTo(another)
    }
    
    public func compare(date: Date, ifLater another: Date) -> Bool {
        return date.isLater(than: another)
    }
    
    public func compare(date: Date, ifLaterThanOrEqualTo another: Date) -> Bool {
        return date.isLaterThanOrEqualTo(another)
    }
    
    public func compare(date: Date, ifEqualTo another: Date) -> Bool {
        return date.isEqualTo(another)
    }
    
    public func compare(date: Date, ifNotEqualTo another: Date) -> Bool {
        return !date.isEqualTo(another)
    }
    
    // MARK: - Calculating
    
    public static func dateBy(_ calculating: TimeCalculatingOperation, _ value: Int, of type: TimePeriodSize, to date: Date) -> Date? {
        return Dawn.calendar.date(by: calculating, value, of: type, to:date)
    }
    
    public func dateBy(_ calculating: TimeCalculatingOperation, _ value: Int, of type: TimePeriodSize, to date: Date) -> Date? {
        return calendar.date(by: calculating, value, of: type, to:date)
    }
    
    // MARK: Adding components to dates
    public static func dateByAdding(_ value: Int, of type: TimePeriodSize, to date: Date) -> Date? {
        return Dawn.calendar.date(by: .adding, value, of: type, to: date)
    }
    
    public func dateByAdding(_ value: Int, of type: TimePeriodSize, to date: Date) -> Date? {
        return Dawn.calendar.date(by: .adding, value, of: type, to: date)
    }
    
    public static func dateByAdding(years: Int, to date: Date) -> Date? {
        return Dawn.calendar.date(byAdding: years, of: .year, to: date)
    }
    
    public static func dateByAdding(months: Int, to date: Date) -> Date? {
        return Dawn.calendar.date(byAdding: months, of: .month, to: date)
    }
    
    public static func dateByAdding(weeks: Int, to date: Date) -> Date? {
        return Dawn.calendar.date(byAdding: weeks, of: .week, to: date)
    }
    
    public static func dateByAdding(days: Int, to date: Date) -> Date? {
        return Dawn.calendar.date(byAdding: days, of: .day, to: date)
    }
    
    public static func dateByAdding(hours: Int, to date: Date) -> Date? {
        return Dawn.calendar.date(byAdding: hours, of: .hour, to: date)
    }
    
    public static func dateByAdding(minutes: Int, to date: Date) -> Date? {
        return Dawn.calendar.date(byAdding: minutes, of: .minute, to: date)
    }
    
    public static func dateByAdding(seconds: Int, to date: Date) -> Date? {
        return Dawn.calendar.date(byAdding: seconds, of: .second, to: date)
    }
    
    // MARK: Subtracting components from dates
    public static func dateBySubtracting(_ value: Int, of type: TimePeriodSize, to date: Date) -> Date? {
        return Dawn.calendar.date(by: .subtracting, value, of: type, to: date)
    }
    
    public func dateBySubtracting(_ value: Int, of type: TimePeriodSize, to date: Date) -> Date? {
        return calendar.date(by: .subtracting, value, of: type, to: date)
    }
    
    public static func dateBySubtracting(years: Int, from date: Date) -> Date? {
        return Dawn.calendar.date(bySubtracting: years, of: .year, to: date)
    }
    
    public static func dateBySubtracting(months: Int, from date: Date) -> Date? {
        return Dawn.calendar.date(bySubtracting: months, of: .month, to: date)
    }
    
    public static func dateBySubtracting(weeks: Int, from date: Date) -> Date? {
        return Dawn.calendar.date(bySubtracting: weeks, of: .week, to: date)
    }
    
    public static func dateBySubtracting(days: Int, from date: Date) -> Date? {
        return Dawn.calendar.date(bySubtracting: days, of: .day, to: date)
    }
    
    public static func dateBySubtracting(hours: Int, from date: Date) -> Date? {
        return Dawn.calendar.date(bySubtracting: hours, of: .hour, to: date)
    }
    
    public static func dateBySubtracting(minutes: Int, from date: Date) -> Date? {
        return Dawn.calendar.date(bySubtracting: minutes, of: .minute, to: date)
    }
    
    public static func dateBySubtracting(seconds: Int, from date: Date) -> Date? {
        return Dawn.calendar.date(bySubtracting: seconds, of: .second, to: date)
    }
    
    // MARK: - Counting components between dates
    
    public static func counting(_ expected: DateCountingUnit, from firstDate: Date, to secondDate: Date) -> Int? {
        return Dawn.calendar.counting(expected, from: firstDate, to: secondDate)
    }
    
    public static func years(from firstDate: Date, to secondDate: Date) -> Int? {
        return Dawn.calendar.counting(.years, from: firstDate, to: secondDate)
    }
    
    public static func months(from firstDate: Date, to secondDate: Date) -> Int? {
        return Dawn.calendar.counting(.months, from: firstDate, to: secondDate)
    }
    
    public static func weeks(from firstDate: Date, to secondDate: Date) -> Int? {
        return Dawn.calendar.counting(.weeks, from: firstDate, to: secondDate)
    }
    
    public static func days(from firstDate: Date, to secondDate: Date) -> Int? {
        return Dawn.calendar.counting(.days, from: firstDate, to: secondDate)
    }
}
