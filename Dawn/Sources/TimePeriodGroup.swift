//
//  TimePeriodGroup.swift
//  Dawn
//
//  Copyright 2015 Meniny
//

import Foundation

public protocol TimePeriodGroup {
    // MARK: - Date properties
    /**
      Number of time periods in group
    */
    var count: Int { get }
    
    /**
      Array containing TimePeriod objects
    */
    var periods: [TimePeriod] { get }
    
    /**
      The start date of a group representing the earliest date of the time periods
    */
    var startDate: Date? { get }
    
    /**
      The end date of a group representing the latest date of the time periods
    */
    var endDate: Date? { get }
    
    /**
      Calendar used for date calculations
    */
    var calendar: Calendar { get }

    subscript(index: Int) -> TimePeriod { get set }
    
    // MARK: - Duration properties
    var durationInYears:   Int { get }
    var durationInMonths:  Int { get }
    var durationInWeeks:   Int { get }
    var durationInDays:    Int { get }
    var durationInHours:   Int { get }
    var durationInMinutes: Int { get }
    var durationInSeconds: Int { get }
    
    // MARK: - Methods
    /**
        Returns the duration of the receiver in given TimePeriodSize
    
        - parameter size: Desired period size
    
        - returns: duration of the receiver in given `TimePeriodSize`
    */
    func duration(in size: TimePeriodSize) -> Int
    
    /**
        Shifts all TimePeriod objects later by a given size amount. Amount multiplies size.
    
        - parameter size: Desired shift size
        - parameter amount: Multiplier of size
    */
    func shiftLater(with size: TimePeriodSize, amount: Int)
    
    /**
        Shifts all TimePeriod objects earlier by a given size amount. Amount multiplies size.
    
        - parameter size: Desired shift size
        - parameter amount: Multiplier of size
    */
    func shiftEarlier(with size: TimePeriodSize, amount: Int)
    
    /**
        Checks whether given TimePeriodGroup has the same startDate, endDate and number of TimePeriod objects
    
        - parameter timePeriodGroup: `TimePeriodGroup` object to compare receiver to
    
        - returns: true if given `TimePeriodGroup` has the same characteristics as the receiver, false otherwise
    */
    func hasSameCharacteristicsAs(timePeriodGroup: TimePeriodGroup) -> Bool
}

public extension TimePeriodGroup {
    // MARK: - Properties
    public var count: Int { get { return self.periods.count } }
    
    public var durationInYears: Int {
        get {
            guard let startDate = self.startDate, let endDate = self.endDate else { return 0 }
            return self.calendar.yearsEarlier(endDate, than: startDate) ?? 0
        }
    }
    
    public var durationInMonths: Int {
        get {
            guard let startDate = self.startDate, let endDate = self.endDate else { return 0 }
            return self.calendar.monthsEarlier(endDate, than: startDate) ?? 0
        }
    }
    
    public var durationInWeeks: Int {
        get {
            guard let startDate = self.startDate, let endDate = self.endDate else { return 0 }
            return self.calendar.weeksEarlier(endDate, than: startDate) ?? 0
        }
    }
    
    public var durationInDays: Int {
        get {
            guard let startDate = self.startDate, let endDate = self.endDate else { return 0 }
            return self.calendar.daysEarlier(endDate, than: startDate) ?? 0
        }
    }
    
    public var durationInHours: Int {
        get {
            guard let startDate = self.startDate, let endDate = self.endDate else { return 0 }
            return Int(self.calendar.hoursEarlier(endDate, than: startDate) ?? 0)
        }
    }
    
    public var durationInMinutes: Int {
        get {
            guard let startDate = self.startDate, let endDate = self.endDate else { return 0 }
            return Int(self.calendar.minutesEarlier(endDate, than: startDate) ?? 0)
        }
    }
    
    public var durationInSeconds: Int {
        get {
            guard let startDate = self.startDate, let endDate = self.endDate else { return 0 }
            return Int(self.calendar.secondsEarlier(endDate, than: startDate) ?? 0)
        }
    }
    
    public func duration(in size: TimePeriodSize) -> Int {
        switch size {
        case .second:
            return self.durationInSeconds
        case .minute:
            return self.durationInMinutes
        case .hour:
            return self.durationInHours
        case .day:
            return self.durationInDays
        case .week:
            return self.durationInWeeks
        case .month:
            return self.durationInMonths
        case .year:
            return self.durationInYears
        }
    }
    
    public func shiftLater(with size: TimePeriodSize, amount: Int = 1) {
        self.periods.forEach { elem in
            elem.shiftLater(withSize: size, amount: amount)
        }
    }
    
    public func shiftEarlier(with size: TimePeriodSize, amount: Int) {
        self.periods.forEach { elem in
            elem.shiftEarlier(withSize: size, amount: amount)
        }
    }
    
    public func hasSameCharacteristicsAs(timePeriodGroup: TimePeriodGroup) -> Bool {
        if timePeriodGroup.count != self.count {
            return false
        } else if timePeriodGroup.count == 0 {
            return true
        } else if timePeriodGroup.startDate != self.startDate || timePeriodGroup.endDate != self.endDate {
            return false
        }
        return true
    }
 
}

