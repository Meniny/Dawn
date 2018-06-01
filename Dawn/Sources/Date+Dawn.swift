//
//  Date+Dawn.swift
//  Dawn
//
//  Copyright 2015 Meniny
//

import Foundation

public extension Date {
    
    /**
     *  Retrieves a default Calendar instance, based on the value of defaultCalendarSetting
     *
     *  @return Calendar The current implicit calendar
     */
    public static var implicitCalendar: Calendar = Calendar(identifier: .gregorian)
    
    private static var allCalendarUnitFlags: Set<Calendar.Component> = [.year, .quarter, .month, .weekOfYear, .weekOfMonth, .day, .hour, .minute, .second, .era, .weekday, .weekdayOrdinal, .weekOfYear]
    
    /**
     *  Retrieves the default calendar identifier used for all non-calendar-specified operations
     *
     *  @return String - Calendar.Identifier
     */
    public static var defaultCalendarIdentifier : Calendar.Identifier {
        get {
            return implicitCalendar.identifier
        }
        set {
            if newValue != implicitCalendar.identifier {
                implicitCalendar = Calendar(identifier: newValue)
            }
        }
    }
    
    // MARK: - Date Creating
    
    public static func date(dateString: String, formatString: String, timeZone: TimeZone = TimeZone.current) -> Date  {
        let parser = DateFormatter()
        parser.dateStyle = .none
        parser.timeStyle = .none
        parser.timeZone = timeZone
        parser.dateFormat = formatString
        
        return parser.date(from: dateString)!
    }
    
    public static func date(year: Int = 1970, month: Int = 1, day: Int = 1, hour: Int = 0, minute: Int = 0, second: Int = 0) -> Date {
        var components = DateComponents()
        
        components.year   = year
        components.month  = month
        components.day    = day
        components.hour   = hour
        components.minute = minute
        components.second = second
        
        return Calendar.current.date(from: components)!
    }
    
    // MARK: - Time Ago
    
    /**
     *  Takes in a date and returns a string with the most convenient unit of time representing
     *  how far in the past that date is from now.
     *
     *  @param date - Date to be measured from now
     *
     *  @return String - Formatted return string
     */
    public static func timeAgo(since date: Date) -> String? {
        return date.timeAgo(since: Date())
    }
    
    /**
     *  Takes in a date and returns a shortened string with the most convenient unit of time representing
     *  how far in the past that date is from now.
     *
     *  @param date - Date to be measured from now
     *
     *  @return String - Formatted return string
     */
    public static func shortTimeAgo(since date: Date) -> String? {
        return date.shortTimeAgo(since: Date())
    }
    
    public static func weekTimeAgo(since date: Date) -> String? {
        return date.weekTimeAgo(since: Date())
    }
    
    /**
     *  Returns a string with the most convenient unit of time representing
     *  how far in the past that date is from now.
     *
     *  @return String - Formatted return string
     */
    public func timeAgoSinceNow() -> String? {
        return self.timeAgo(since: Date())
    }
    
    /**
     *  Returns a shortened string with the most convenient unit of time representing
     *  how far in the past that date is from now.
     *
     *  @return String - Formatted return string
     */
    public func shortTimeAgoSinceNow() -> String?  {
        return self.shortTimeAgo(since: Date())
    }
    
    public func weekTimeAgoSinceNow() -> String?  {
        return self.weekTimeAgo(since: Date())
    }
    
    public func timeAgo(since: Date) -> String?  {
        return self.timeAgo(since: since, numericDates: false)
    }
    
    public func timeAgo(since: Date, numericDates useNumericDates: Bool) -> String?  {
        return self.timeAgo(since: since, numericDates: useNumericDates, numericTimes: false)
    }
    
    public func timeAgo(since date: Date, numericDates useNumericDates: Bool, numericTimes useNumericTimes: Bool) -> String?  {
        if useNumericDates && useNumericTimes {
            return self.timeAgo(since: date, format: .longUsingNumericDatesAndTimes)
        } else if useNumericDates {
            return self.timeAgo(since: date, format: .longUsingNumericDates)
        } else if useNumericTimes {
            return self.timeAgo(since: date, format: .longUsingNumericDates)
        } else {
            return self.timeAgo(since: date, format: .long)
        }
    }
    
    public func shortTimeAgo(since: Date) -> String?  {
        return self.timeAgo(since: since, format: .short)
    }
    
    public func weekTimeAgo(since: Date) -> String?  {
        return self.timeAgo(since: since, format: .week)
    }
    
    public func timeAgo(since date: Date, format: DateAgoFormat) -> String?  {
    
        let calendar = Calendar.current
        var earliest = (self as NSDate).earlierDate(date)
        var latest = (earliest == self) ? date : self
    
        // if timeAgo < 24h => compare DateTime else compare Date only
        let upToHours: Set<Calendar.Component> = [.second, .minute, .hour]
        var difference = calendar.dateComponents(upToHours, from: earliest, to: latest)
        
        if difference.hour! < 24 {
            if difference.hour! >= 1 {
                return self.localizedString(format: format, valueType: .hours, value: difference.hour!)
            } else if difference.minute! >= 1 {
                return self.localizedString(format: format, valueType: .minutes, value: difference.minute!)
            } else {
                return self.localizedString(format: format, valueType: .seconds, value: difference.second!)
            }
        
        } else {
            let bigUnits: Set<Calendar.Component> = [.timeZone, .day, .weekOfYear, .month, .year]
            
            var components = calendar.dateComponents(bigUnits, from: earliest)
            earliest = calendar.date(from: components)!
            
            components = calendar.dateComponents(bigUnits, from: latest)
            latest = calendar.date(from: components)!
            
            difference = calendar.dateComponents(bigUnits, from: earliest, to: latest)
            
            if difference.year! >= 1 {
                return self.localizedString(format: format, valueType: .years, value: difference.year!)
            } else if difference.month! >= 1 {
                return self.localizedString(format: format, valueType: .months, value: difference.month!)
            } else if difference.weekOfYear! >= 1 {
                return self.localizedString(format: format, valueType: .weeks, value: difference.weekOfYear!)
            } else {
                return self.localizedString(format: format, valueType: .days, value: difference.day!)
            }
        }
    }
    
    private func localizedString(format: DateAgoFormat, valueType: DateAgoUnit, value: Int) -> String?  {
        let isShort = format == .short
        let isNumericDate = format == .longUsingNumericDates || format == .longUsingNumericDatesAndTimes
        let isNumericTime = format == .longUsingNumericTimes || format == .longUsingNumericDatesAndTimes
        let isWeek =  format == .week
        
        switch (valueType) {
        case .years:
            if isShort {
                return self.logicLocalizedString(fromFormat:"%%d%@y", withValue: value)
            } else if value >= 2 {
                return self.logicLocalizedString(fromFormat:"%%d %@years ago", withValue: value)
            } else if isNumericDate {
                return DawnLocalizedStrings("1 year ago")
            } else {
                return DawnLocalizedStrings("Last year")
            }
        case .months:
            if isShort {
                return self.logicLocalizedString(fromFormat:"%%d%@M", withValue: value)
            } else if value >= 2 {
                return self.logicLocalizedString(fromFormat:"%%d %@months ago", withValue: value)
            } else if isNumericDate {
                return DawnLocalizedStrings("1 month ago")
            } else {
                return DawnLocalizedStrings("Last month")
            }
        case .weeks:
            if isShort {
                return self.logicLocalizedString(fromFormat:"%%d%@w", withValue: value)
            } else if value >= 2 {
                return self.logicLocalizedString(fromFormat:"%%d %@weeks ago", withValue: value)
            } else if isNumericDate {
                return DawnLocalizedStrings("1 week ago")
            } else {
                return DawnLocalizedStrings("Last week")
            }
        case .days:
            if isShort {
                return self.logicLocalizedString(fromFormat:"%%d%@d", withValue: value)
            } else if value >= 2 {
                if isWeek && value <= 7 {
                    let dayDateFormatter = DateFormatter()
                    dayDateFormatter.dateFormat = "EEE"
                    let eee = dayDateFormatter.string(from: self)
                    
                    return DawnLocalizedStrings(eee)
                }
            
                return self.logicLocalizedString(fromFormat:"%%d %@days ago", withValue: value)
            } else if isNumericDate {
                return DawnLocalizedStrings("1 day ago")
            } else {
                return DawnLocalizedStrings("Yesterday")
            }
        case .hours:
            if isShort {
                return self.logicLocalizedString(fromFormat:"%%d%@h", withValue: value)
            } else if value >= 2 {
                return self.logicLocalizedString(fromFormat:"%%d %@hours ago", withValue: value)
            } else if isNumericTime {
                return DawnLocalizedStrings("1 hour ago")
            } else {
                return DawnLocalizedStrings("An hour ago")
            }
        case .minutes:
            if isShort {
                return self.logicLocalizedString(fromFormat:"%%d%@m", withValue: value)
            } else if value >= 2 {
                return self.logicLocalizedString(fromFormat:"%%d %@minutes ago", withValue: value)
            } else if isNumericTime {
                return DawnLocalizedStrings("1 minute ago")
            } else {
                return DawnLocalizedStrings("A minute ago")
            }
        case .seconds:
            if isShort {
                return self.logicLocalizedString(fromFormat:"%%d%@s", withValue: value)
            } else if value >= 2 {
                return self.logicLocalizedString(fromFormat:"%%d %@seconds ago", withValue: value)
            } else if isNumericTime {
                return DawnLocalizedStrings("1 second ago")
            } else {
                return DawnLocalizedStrings("Just now")
            }
        }
    }
    
    private func logicLocalizedString(fromFormat format: String, withValue value: Int) -> String  {
        let localeFormat = String(format: format, self.getLocaleFormatUnderscores(withValue: value))
        return String(format: DawnLocalizedStrings(localeFormat), value)
    }
    
    private func getLocaleFormatUnderscores(withValue value: Int) -> String  {
        let localeCode = Bundle.main.preferredLocalizations[0]
        
        // Russian (ru) and Ukrainian (uk)
        if localeCode == "ru-RU" || localeCode == "uk" {
            let XY = value % 100
            let Y = value % 10
        
            if Y == 0 || Y > 4 || (XY > 10 && XY < 15) {
                return ""
            }
            
            if Y > 1 && Y < 5 && (XY < 10 || XY > 20) {
                return "_"
            }
            
            if Y == 1 && XY != 11 {
                return "__"
            }
        }
        
        // Add more languages here, which are have specific translation rules...
    
        return ""
    }
    
    // MARK: - Date Components Without Calendar
    
    /**
     *  Returns the era of the receiver. (0 for BC, 1 for AD for Gregorian)
     *
     *  @return Int
     */
    public var era: Int {
        return self.componentFor(date: self, type: .era, calendar: nil)
    }
    
    /**
     *  Returns the year of the receiver.
     *
     *  @return Int
     */
    public var year: Int {
        return self.componentFor(date: self, type: .year, calendar: nil)
    }
    
    /**
     *  Returns the month of the year of the receiver.
     *
     *  @return Int
     */
    public var month: Int {
        return self.componentFor(date: self, type: .month, calendar: nil)
    }
    
    /**
     *  Returns the day of the month of the receiver.
     *
     *  @return Int
     */
    public var day: Int {
        return self.componentFor(date: self, type: .day, calendar: nil)
    }
    
    /**
     *  Returns the hour of the day of the receiver. (0-24)
     *
     *  @return Int
     */
    public var hour: Int {
        return self.componentFor(date: self, type: .hour, calendar: nil)
    }
    
    /**
     *  Returns the minute of the receiver. (0-59)
     *
     *  @return Int
     */
    public var minute: Int {
        return self.componentFor(date: self, type: .minute, calendar: nil)
    }
    
    /**
     *  Returns the second of the receiver. (0-59)
     *
     *  @return Int
     */
    public var second: Int {
        return self.componentFor(date: self, type: .second, calendar: nil)
    }
    
    /**
     *  Returns the day of the week of the receiver.
     *
     *  @return Int
     */
    public var weekday: Int {
        return self.componentFor(date: self, type: .weekday, calendar: nil)
    }
    
    /**
     *  Returns the day of the week of the receiver.
     *
     *  @return enum `WeekdayName`
     */
    public var weekdayName: WeekdayName {
        return WeekdayName(rawValue: self.componentFor(date: self, type: .weekday, calendar: nil))!
    }
    
    /**
     *  Returns the ordinal for the day of the week of the receiver.
     *
     *  @return Int
     */
    public var weekdayOrdinal: Int {
        return self.componentFor(date: self, type: .weekdayOrdinal, calendar: nil)
    }
    
    /**
     *  Returns the quarter of the receiver.
     *
     *  @return Int
     */
    public var quarter: Int {
        return self.componentFor(date: self, type: .quarter, calendar: nil)
    }
    
    /**
     *  Returns the week of the month of the receiver.
     *
     *  @return Int
     */
    public var weekOfMonth: Int {
        return self.componentFor(date: self, type: .weekOfMonth, calendar: nil)
    }
    
    /**
     *  Returns the week of the year of the receiver.
     *
     *  @return Int
     */
    public var weekOfYear: Int {
        return self.componentFor(date: self, type: .weekOfYear, calendar: nil)
    }
    
    /**
     *  I honestly don't know much about this value...
     *
     *  @return Int
     */
    public var yearForWeekOfYear: Int {
        return self.componentFor(date: self, type: .yearForWeekOfYear, calendar: nil)
    }
    
    /**
     *  Returns how many days are in the month of the receiver.
     *
     *  @return Int
     */
    public var daysInMonth: Int {
        let calendar = Calendar.current
        let days = calendar.range(of: .day, in: .month, for: self)!
        return days.upperBound - 1
    }
    
    /**
     *  Returns the day of the year of the receiver. (1-365 or 1-366 for leap year)
     *
     *  @return Int
     */
    public var dayOfYear: Int {
        return self.componentFor(date: self, type: .dayOfYear, calendar: nil)
    }
    
    /**
     *  Returns how many days are in the year of the receiver.
     *
     *  @return Int
     */
    public var daysInYear: Int {
        if self.isInLeapYear {
            return 366
        }
        
        return 365
    }
    
    /**
     *  Returns whether the receiver falls in a leap year.
     *
     *  @return Int
     */
    public var isInLeapYear: Bool {
        let calendar = Date.self.implicitCalendar
        let dateComponents = calendar.dateComponents(Date.self.allCalendarUnitFlags, from: self)
        
        if dateComponents.year! % 400 == 0 {
            return true
        }
        else if dateComponents.year! % 100 == 0 {
            return false
        }
        else if dateComponents.year! % 4 == 0 {
            return true
        }
    
        return false
    }
    
    public var isToday: Bool {
        let cal = Calendar.current
        var components = cal.dateComponents([.era, .year, .month, .day], from: Date())
        let today = cal.date(from: components)
        components = cal.dateComponents([.era, .year, .month, .day], from: self)
        let otherDate = cal.date(from: components)
    
        return today == otherDate
    }
    
    public var isTomorrow: Bool {
        let cal = Calendar.current
        var components = cal.dateComponents([.era, .year, .month, .day], from: Date().adding(days: 1))
        let tomorrow = cal.date(from: components)
        components = cal.dateComponents([.era, .year, .month, .day], from: self)
        let otherDate = cal.date(from: components)
    
        return tomorrow == otherDate
    }
    
    public var isYesterday: Bool {
        let cal = Calendar.current
        var components = cal.dateComponents([.era, .year, .month, .day], from: Date().subtracting(days: 1))
        let tomorrow = cal.date(from: components)
        components = cal.dateComponents([.era, .year, .month, .day], from: self)
        let otherDate = cal.date(from: components)
    
        return tomorrow == otherDate
    }
    
    public var isWeekend: Bool {
        let calendar = Calendar.current
        let weekdayRange = calendar.maximumRange(of: .weekday)!
        let components = calendar.dateComponents([.weekday], from: self)
        let weekdayOfSomeDate = components.weekday!
        
        var result = false
        
        if weekdayOfSomeDate == weekdayRange.lowerBound || weekdayOfSomeDate == weekdayRange.upperBound - 1 {
            result = true
        }
    
        return result
    }
    
    
    /**
     *  Returns whether two dates fall on the same day.
     *
     *  @param date Date - Date to compare with sender
     *  @return Bool - YES if both paramter dates fall on the same day, NO otherwise
     */
    public func isSameDay(_ date: Date) -> Bool {
        return Date.isSameDay(date: self, asDate: date)
    }
    
    /**
     *  Returns whether two dates fall on the same day.
     *
     *  @param date Date - First date to compare
     *  @param compareDate Date - Second date to compare
     *  @return Bool - YES if both paramter dates fall on the same day, NO otherwise
     */
    public static func isSameDay(date: Date, asDate compareDate: Date) -> Bool {
        let cal = Calendar.current
    
        var components = cal.dateComponents([.era, .year, .month, .day], from: date)
        let dateOne = cal.date(from: components)
    
        components = cal.dateComponents([.era, .year, .month, .day], from: compareDate)
        let dateTwo = cal.date(from: components)
    
        return dateOne == dateTwo
    }
    
    // MARK: - Date Components With Calendar
    /**
     *  Returns the era of the receiver from a given calendar
     *
     *  @param calendar Calendar - The calendar to be used in the calculation
     *
     *  @return Int - represents the era (0 for BC, 1 for AD for Gregorian)
     */
    public func era(with calendar: Calendar = .current) -> Int {
        return self.componentFor(date: self, type: .era, calendar: calendar)
    }
    
    /**
     *  Returns the year of the receiver from a given calendar
     *
     *  @param calendar Calendar - The calendar to be used in the calculation
     *
     *  @return Int - represents the year as an Int
     */
    public func year(with calendar: Calendar = .current) -> Int {
        return self.componentFor(date: self, type: .year, calendar: calendar)
    }
    
    /**
     *  Returns the month of the receiver from a given calendar
     *
     *  @param calendar Calendar - The calendar to be used in the calculation
     *
     *  @return Int - represents the month as an Int
     */
    public func month(with calendar: Calendar = .current) -> Int {
        return self.componentFor(date: self, type: .month, calendar: calendar)
    }
    
    /**
     *  Returns the day of the month of the receiver from a given calendar
     *
     *  @param calendar Calendar - The calendar to be used in the calculation
     *
     *  @return Int - represents the day of the month as an Int
     */
    public func day(with calendar: Calendar = .current) -> Int {
        return self.componentFor(date: self, type: .day, calendar: calendar)
    }
    
    /**
     *  Returns the hour of the day of the receiver from a given calendar
     *
     *  @param calendar Calendar - The calendar to be used in the calculation
     *
     *  @return Int - represents the hour of the day as an Int
     */
    public func hour(with calendar: Calendar = .current) -> Int {
        return self.componentFor(date: self, type: .hour, calendar: calendar)
    }
    
    /**
     *  Returns the minute of the hour of the receiver from a given calendar
     *
     *  @param calendar Calendar - The calendar to be used in the calculation
     *
     *  @return Int - represents the minute of the hour as an Int
     */
    public func minute(with calendar: Calendar = .current) -> Int {
        return self.componentFor(date: self, type: .minute, calendar: calendar)
    }
    
    /**
     *  Returns the second of the receiver from a given calendar
     *
     *  @param calendar Calendar - The calendar to be used in the calculation
     *
     *  @return Int - represents the second as an Int
     */
    public func second(with calendar: Calendar = .current) -> Int {
        return self.componentFor(date: self, type: .second, calendar: calendar)
    }
    
    /**
     *  Returns the weekday of the receiver from a given calendar
     *
     *  @param calendar Calendar - The calendar to be used in the calculation
     *
     *  @return Int - represents the weekday as an Int
     */
    public func weekday(with calendar: Calendar = .current) -> Int {
        return self.componentFor(date: self, type: .weekday, calendar: calendar)
    }
    
    /**
     *  Returns the weekday of the receiver from a given calendar
     *
     *  @param calendar Calendar - The calendar to be used in the calculation
     *
     *  @return enum `WeekdayName` - represents the weekday as an Int
     */
    public func weekdayName(with calendar: Calendar = .current) -> WeekdayName {
        return WeekdayName(rawValue: self.componentFor(date: self, type: .weekday, calendar: calendar))!
    }
    
    /**
     *  Returns the weekday ordinal of the receiver from a given calendar
     *
     *  @param calendar Calendar - The calendar to be used in the calculation
     *
     *  @return Int - represents the weekday ordinal as an Int
     */
    public func weekdayOrdinal(with calendar: Calendar = .current) -> Int {
        return self.componentFor(date: self, type: .weekdayOrdinal, calendar: calendar)
    }
    
    /**
     *  Returns the quarter of the receiver from a given calendar
     *
     *  @param calendar Calendar - The calendar to be used in the calculation
     *
     *  @return Int - represents the quarter as an Int
     */
    public func quarter(with calendar: Calendar = .current) -> Int {
        return self.componentFor(date: self, type: .quarter, calendar: calendar)
    }
    
    /**
     *  Returns the week of the month of the receiver from a given calendar
     *
     *  @param calendar Calendar - The calendar to be used in the calculation
     *
     *  @return Int - represents the week of the month as an Int
     */
    public func weekOfMonth(with calendar: Calendar = .current) -> Int {
        return self.componentFor(date: self, type: .weekOfMonth, calendar: calendar)
    }
    
    /**
     *  Returns the week of the year of the receiver from a given calendar
     *
     *  @param calendar Calendar - The calendar to be used in the calculation
     *
     *  @return Int - represents the week of the year as an Int
     */
    public func weekOfYear(with calendar: Calendar = .current) -> Int {
        return self.componentFor(date: self, type: .weekOfYear, calendar: calendar)
    }
    
    /**
     *  Returns the year for week of the year (???) of the receiver from a given calendar
     *
     *  @param calendar Calendar - The calendar to be used in the calculation
     *
     *  @return Int - represents the year for week of the year as an Int
     */
    public func yearForWeekOfYear(with calendar: Calendar = .current) -> Int {
        return self.componentFor(date: self, type: .yearForWeekOfYear, calendar: calendar)
    }
    
    
    /**
     *  Returns the day of the year of the receiver from a given calendar
     *
     *  @param calendar Calendar - The calendar to be used in the calculation
     *
     *  @return Int - represents the day of the year as an Int
     */
    public func dayOfYear(with calendar: Calendar = .current) -> Int {
        return self.componentFor(date: self, type: .dayOfYear, calendar: calendar)
    }
    
    /**
     *  Takes in a date, calendar and desired date component and returns the desired Int
     *  representation for that component
     *
     *  @param date      Date - The date to be be mined for a desired component
     *  @param component DTDateComponent - The desired component (i.e. year, day, week, etc)
     *  @param calendar  Calendar - The calendar to be used in the processing (Defaults to Gregorian)
     *
     *  @return Int
     */
    private func componentFor(date: Date, type component: DawnDateComponent, calendar fromCalendar: Calendar?) -> Int {
        let calendar = fromCalendar ?? Date.self.implicitCalendar
        var unitFlags: Set<Calendar.Component>
        
        if component == .yearForWeekOfYear {
            unitFlags = [.year, .quarter, .month, .weekOfYear, .weekOfMonth, .day, .hour, .minute, .second, .era, .weekday, .weekdayOrdinal, .weekOfYear, .yearForWeekOfYear]
        } else {
            unitFlags = Date.self.allCalendarUnitFlags
        }
    
        let dateComponents = calendar.dateComponents(unitFlags, from: date)
        
        switch (component) {
        case .era:
            return dateComponents.era!
        case .year:
            return dateComponents.year!
        case .month:
            return dateComponents.month!
        case .day:
            return dateComponents.day!
        case .hour:
            return dateComponents.hour!
        case .minute:
            return dateComponents.minute!
        case .second:
            return dateComponents.second!
        case .weekday:
            return dateComponents.weekday!
        case .weekdayOrdinal:
            return dateComponents.weekdayOrdinal!
        case .quarter:
            return dateComponents.quarter!
        case .weekOfMonth:
            return dateComponents.weekOfMonth!
        case .weekOfYear:
            return dateComponents.weekOfYear!
        case .yearForWeekOfYear:
            return dateComponents.yearForWeekOfYear!
        case .dayOfYear:
            return calendar.ordinality(of: .day, in: .year, for: date)!
        }
    }

    public func date(by calculating: TimeCalculatingOperation, _ value: Int, of type: TimePeriodSize, to date: Date) -> Date? {
        return Calendar.current.date(by: calculating, value, of: type, to:date)
    }
    
    // MARK: - Adding components to date
    public func adding(_ value: Int, of type: TimePeriodSize, to date: Date) -> Date? {
        return Calendar.current.date(by: .adding, value, of: type, to: date)
    }
    
    public func adding(years: Int) -> Date {
        return Calendar.current.dateByAdding(years: years, to: self)!
    }
    
    public func adding(months: Int) -> Date {
        return Calendar.current.dateByAdding(months: months, to: self)!
    }
    
    public func adding(weeks: Int) -> Date {
        return Calendar.current.dateByAdding(weeks: weeks, to: self)!
    }
    
    public func adding(days: Int) -> Date {
        return Calendar.current.dateByAdding(days: days, to: self)!
    }
    
    public func adding(hours: Int) -> Date {
        return Calendar.current.dateByAdding(hours: hours, to: self)!
    }
    
    public func adding(minutes: Int) -> Date {
        return Calendar.current.dateByAdding(minutes: minutes, to: self)!
    }
    
    public func adding(seconds: Int) -> Date {
        return Calendar.current.dateByAdding(seconds: seconds, to: self)!
    }
    
    // MARK: - Subtracting components from date
    public func subtracting(_ value: Int, of type: TimePeriodSize, to date: Date) -> Date? {
        return Calendar.current.date(by: .subtracting, value, of: type, to: date)
    }
    
    public func subtracting(years: Int) -> Date {
        return Calendar.current.dateBySubtracting(years: years, from: self)!
    }
    
    public func subtracting(months: Int) -> Date {
        return Calendar.current.dateBySubtracting(months: months, from: self)!
    }
    
    public func subtracting(weeks: Int) -> Date {
        return Calendar.current.dateBySubtracting(weeks: weeks, from: self)!
    }
    
    public func subtracting(days: Int) -> Date {
        return Calendar.current.dateBySubtracting(days: days, from: self)!
    }
    
    public func subtracting(hours: Int) -> Date {
        return Calendar.current.dateBySubtracting(hours: hours, from: self)!
    }
    
    public func subtracting(minutes: Int) -> Date {
        return Calendar.current.dateBySubtracting(minutes: minutes, from: self)!
    }
    
    public func subtracting(seconds: Int) -> Date {
        return Calendar.current.dateBySubtracting(seconds: seconds, from: self)!
    }
    
    // MARK: - Date Comparison


    /**
     *  Returns an Int representing the amount of time in years between the receiver and the provided date.
     *  If the receiver is earlier than the provided date, the returned value will be negative.
     *
     *  @param date     Date - The provided date for comparison
     *  @param calendar Calendar - The calendar to be used in the calculation
     *
     *  @return Int - The double representation of the years between receiver and provided date
     */
    public func years(from date: Date, calendar: Calendar = Date.self.implicitCalendar) -> Int {
        let earliest = (self as NSDate).earlierDate(date)
        let latest = (earliest == self) ? date : self
        let multiplier = (earliest == self) ? -1 : 1
        let components = calendar.dateComponents([.year], from: earliest, to: latest)
        return multiplier*components.year!
    }
    
    /**
     *  Returns an Int representing the amount of time in months between the receiver and the provided date.
     *  If the receiver is earlier than the provided date, the returned value will be negative.
     *
     *  @param date     Date - The provided date for comparison
     *  @param calendar Calendar - The calendar to be used in the calculation
     *
     *  @return Int - The double representation of the months between receiver and provided date
     */
    public func months(from date: Date, calendar: Calendar = Date.self.implicitCalendar) -> Int {
        let earliest = (self as NSDate).earlierDate(date)
        let latest = (earliest == self) ? date : self
        let multiplier = (earliest == self) ? -1 : 1
        let components = calendar.dateComponents(Date.self.allCalendarUnitFlags, from: earliest, to: latest)
        return multiplier*(components.month! + 12*components.year!)
    }
    
    /**
     *  Returns an Int representing the amount of time in weeks between the receiver and the provided date.
     *  If the receiver is earlier than the provided date, the returned value will be negative.
     *
     *  @param date     Date - The provided date for comparison
     *  @param calendar Calendar - The calendar to be used in the calculation
     *
     *  @return Int - The double representation of the weeks between receiver and provided date
     */
    public func weeks(from date: Date, calendar: Calendar = Date.self.implicitCalendar) -> Int {
        let earliest = (self as NSDate).earlierDate(date)
        let latest = (earliest == self) ? date : self
        let multiplier = (earliest == self) ? -1 : 1
        let components = calendar.dateComponents([.weekOfYear], from: earliest, to: latest)
        return multiplier*components.weekOfYear!
    }
    
    /**
     *  Returns an Int representing the amount of time in days between the receiver and the provided date.
     *  If the receiver is earlier than the provided date, the returned value will be negative.
     *
     *  @param date     Date - The provided date for comparison
     *  @param calendar Calendar - The calendar to be used in the calculation
     *
     *  @return Int - The double representation of the days between receiver and provided date
     */
    public func days(from date: Date, calendar: Calendar = Date.self.implicitCalendar) -> Int {
        let earliest = (self as NSDate).earlierDate(date)
        let latest = (earliest == self) ? date : self
        let multiplier = (earliest == self) ? -1 : 1
        let components = calendar.dateComponents([.day], from: earliest, to: latest)
        return multiplier*components.day!
    }

    public func hours(from date: Date) -> Double {
        return self.timeIntervalSince(date) / Double(SecondsConstant.hour.rawValue)
    }

    public func minutes(from date: Date) -> Double {
        return self.timeIntervalSince(date) / Double(SecondsConstant.minute.rawValue)
    }

    public func seconds(from date: Date) -> Double {
        return self.timeIntervalSince(date)
    }

    // MARK: Time Until
    /**
     *  Returns the number of years until the receiver's date. Returns 0 if the receiver is the same or earlier than now.
     *
     *  @return Int representiation of years
     */
    public var yearsUntil: Int {
        return self.yearsLater(than: Date())
    }
    
    /**
     *  Returns the number of months until the receiver's date. Returns 0 if the receiver is the same or earlier than now.
     *
     *  @return Int representiation of months
     */
    public var monthsUntil: Int {
        return self.monthsLater(than: Date())
    }
    
    /**
     *  Returns the number of weeks until the receiver's date. Returns 0 if the receiver is the same or earlier than now.
     *
     *  @return Int representiation of weeks
     */
    public var weeksUntil: Int {
        return self.weeksLater(than: Date())
    }
    
    /**
     *  Returns the number of days until the receiver's date. Returns 0 if the receiver is the same or earlier than now.
     *
     *  @return Int representiation of days
     */
    public var daysUntil: Int {
        return self.daysLater(than: Date())
    }
    
    /**
     *  Returns the number of hours until the receiver's date. Returns 0 if the receiver is the same or earlier than now.
     *
     *  @return double representiation of hours
     */
    public var hoursUntil: Double {
        return self.hoursLater(than: Date())
    }
    
    /**
     *  Returns the number of minutes until the receiver's date. Returns 0 if the receiver is the same or earlier than now.
     *
     *  @return double representiation of minutes
     */
    public var minutesUntil: Double {
        return self.minutesLater(than: Date())
    }
    
    /**
     *  Returns the number of seconds until the receiver's date. Returns 0 if the receiver is the same or earlier than now.
     *
     *  @return double representiation of seconds
     */
    public var secondsUntil: Double {
        return self.secondsLater(than: Date())
    }
    
    // MARK: Time Ago
    /**
     *  Returns the number of years the receiver's date is earlier than now. Returns 0 if the receiver is the same or later than now.
     *
     *  @return Int representiation of years
     */
    public var yearsAgo: Int {
        return self.yearsEarlier(than: Date())
    }
    
    /**
     *  Returns the number of months the receiver's date is earlier than now. Returns 0 if the receiver is the same or later than now.
     *
     *  @return Int representiation of months
     */
    public var monthsAgo: Int {
        return self.monthsEarlier(than: Date())
    }
    
    /**
     *  Returns the number of weeks the receiver's date is earlier than now. Returns 0 if the receiver is the same or later than now.
     *
     *  @return Int representiation of weeks
     */
    public var weeksAgo: Int {
        return self.weeksEarlier(than: Date())
    }
    
    /**
     *  Returns the number of days the receiver's date is earlier than now. Returns 0 if the receiver is the same or later than now.
     *
     *  @return Int representiation of days
     */
    public var daysAgo: Int {
        return self.daysEarlier(than: Date())
    }
    
    /**
     *  Returns the number of hours the receiver's date is earlier than now. Returns 0 if the receiver is the same or later than now.
     *
     *  @return double representiation of hours
     */
    public var hoursAgo: Double {
        return self.hoursEarlier(than: Date())
    }
    
    /**
     *  Returns the number of minutes the receiver's date is earlier than now. Returns 0 if the receiver is the same or later than now.
     *
     *  @return double representiation of minutes
     */
    public var minutesAgo: Double {
        return self.minutesEarlier(than: Date())
    }
    
    /**
     *  Returns the number of seconds the receiver's date is earlier than now. Returns 0 if the receiver is the same or later than now.
     *
     *  @return double representiation of seconds
     */
    public var secondsAgo: Double {
        return self.secondsEarlier(than: Date())
    }
    
    // MARK: Earlier Than
    /**
     *  Returns the number of years the receiver's date is earlier than the provided comparison date.
     *  Returns 0 if the receiver's date is later than or equal to the provided comparison date.
     *
     *  @param date Date - Provided date for comparison
     *
     *  @return Int representing the number of years
     */
    public func yearsEarlier(than date: Date) -> Int {
        return abs(min(self.years(from: date), 0))
    }
    
    /**
     *  Returns the number of months the receiver's date is earlier than the provided comparison date.
     *  Returns 0 if the receiver's date is later than or equal to the provided comparison date.
     *
     *  @param date Date - Provided date for comparison
     *
     *  @return Int representing the number of months
     */
    public func monthsEarlier(than date: Date) -> Int {
        return abs(min(self.months(from: date), 0))
    }
    
    /**
     *  Returns the number of weeks the receiver's date is earlier than the provided comparison date.
     *  Returns 0 if the receiver's date is later than or equal to the provided comparison date.
     *
     *  @param date Date - Provided date for comparison
     *
     *  @return Int representing the number of weeks
     */
    public func weeksEarlier(than date: Date) -> Int {
        return abs(min(self.weeks(from: date), 0))
    }
    
    /**
     *  Returns the number of days the receiver's date is earlier than the provided comparison date.
     *  Returns 0 if the receiver's date is later than or equal to the provided comparison date.
     *
     *  @param date Date - Provided date for comparison
     *
     *  @return Int representing the number of days
     */
    public func daysEarlier(than date: Date) -> Int {
        return abs(min(self.days(from: date), 0))
    }
    
    /**
     *  Returns the number of hours the receiver's date is earlier than the provided comparison date.
     *  Returns 0 if the receiver's date is later than or equal to the provided comparison date.
     *
     *  @param date Date - Provided date for comparison
     *
     *  @return double representing the number of hours
     */
    public func hoursEarlier(than date: Date) -> Double {
        return abs(min(self.hours(from: date), 0))
    }
    
    /**
     *  Returns the number of minutes the receiver's date is earlier than the provided comparison date.
     *  Returns 0 if the receiver's date is later than or equal to the provided comparison date.
     *
     *  @param date Date - Provided date for comparison
     *
     *  @return double representing the number of minutes
     */
    public func minutesEarlier(than date: Date) -> Double {
        return abs(min(self.minutes(from: date), 0))
    }
    
    /**
     *  Returns the number of seconds the receiver's date is earlier than the provided comparison date.
     *  Returns 0 if the receiver's date is later than or equal to the provided comparison date.
     *
     *  @param date Date - Provided date for comparison
     *
     *  @return double representing the number of seconds
     */
    public func secondsEarlier(than date: Date) -> Double {
        return abs(min(self.seconds(from: date), 0))
    }
    
    // MARK: Later Than
    
    /**
     *  Returns the number of years the receiver's date is later than the provided comparison date.
     *  Returns 0 if the receiver's date is earlier than or equal to the provided comparison date.
     *
     *  @param date Date - Provided date for comparison
     *
     *  @return Int representing the number of years
     */
    public func yearsLater(than date: Date) -> Int {
        return max(self.years(from: date), 0)
    }
    
    /**
     *  Returns the number of months the receiver's date is later than the provided comparison date.
     *  Returns 0 if the receiver's date is earlier than or equal to the provided comparison date.
     *
     *  @param date Date - Provided date for comparison
     *
     *  @return Int representing the number of months
     */
    public func monthsLater(than date: Date) -> Int {
        return max(self.months(from: date), 0)
    }
    
    /**
     *  Returns the number of weeks the receiver's date is later than the provided comparison date.
     *  Returns 0 if the receiver's date is earlier than or equal to the provided comparison date.
     *
     *  @param date Date - Provided date for comparison
     *
     *  @return Int representing the number of weeks
     */
    public func weeksLater(than date: Date) -> Int {
        return max(self.weeks(from: date), 0)
    }
    
    /**
     *  Returns the number of days the receiver's date is later than the provided comparison date.
     *  Returns 0 if the receiver's date is earlier than or equal to the provided comparison date.
     *
     *  @param date Date - Provided date for comparison
     *
     *  @return Int representing the number of days
     */
    public func daysLater(than date: Date) -> Int {
        return max(self.days(from: date), 0)
    }
    
    /**
     *  Returns the number of hours the receiver's date is later than the provided comparison date.
     *  Returns 0 if the receiver's date is earlier than or equal to the provided comparison date.
     *
     *  @param date Date - Provided date for comparison
     *
     *  @return double representing the number of hours
     */
    public func hoursLater(than date: Date) -> Double {
        return max(self.hours(from: date), 0)
    }
    
    /**
     *  Returns the number of minutes the receiver's date is later than the provided comparison date.
     *  Returns 0 if the receiver's date is earlier than or equal to the provided comparison date.
     *
     *  @param date Date - Provided date for comparison
     *
     *  @return double representing the number of minutes
     */
    public func minutesLater(than date: Date) -> Double {
        return max(self.minutes(from: date), 0)
    }
    
    /**
     *  Returns the number of seconds the receiver's date is later than the provided comparison date.
     *  Returns 0 if the receiver's date is earlier than or equal to the provided comparison date.
     *
     *  @param date Date - Provided date for comparison
     *
     *  @return double representing the number of seconds
     */
    public func secondsLater(than date: Date) -> Double {
        return max(self.seconds(from: date), 0)
    }
    
    
    // MARK: Comparators
    /**
     *  Returns a YES if receiver is earlier than provided comparison date, otherwise returns NO
     *
     *  @param date Date - Provided date for comparison
     *
     *  @return Bool representing comparison result
     */
    public func isEarlier(than date: Date) -> Bool {
        if self.timeIntervalSince1970 < date.timeIntervalSince1970 {
            return true
        }
        return false
    }
    
    /**
     *  Returns a YES if receiver is later than provided comparison date, otherwise returns NO
     *
     *  @param date Date - Provided date for comparison
     *
     *  @return Bool representing comparison result
     */
    public func isLater(than date: Date) -> Bool {
        if self.timeIntervalSince1970 > date.timeIntervalSince1970 {
            return true
        }
        return false
    }
    
    /**
     *  Returns a YES if receiver is earlier than or equal to the provided comparison date, otherwise returns NO
     *
     *  @param date Date - Provided date for comparison
     *
     *  @return Bool representing comparison result
     */
    public func isEarlierThanOrEqualTo(_ date: Date) -> Bool {
        if self.timeIntervalSince1970 <= date.timeIntervalSince1970 {
            return true
        }
        return false
    }
    
    /**
     *  Returns a YES if receiver is later than or equal to provided comparison date, otherwise returns NO
     *
     *  @param date Date - Provided date for comparison
     *
     *  @return Bool representing comparison result
     */
    public func isLaterThanOrEqualTo(_ date: Date) -> Bool {
        if self.timeIntervalSince1970 >= date.timeIntervalSince1970 {
            return true
        }
        return false
    }
    
    /**
     *  Returns a YES if receiver is equal to provided comparison date, otherwise returns NO
     *
     *  @param date Date - Provided date for comparison
     *
     *  @return Bool representing comparison result
     */
    public func isEqualTo(_ date: Date) -> Bool {
        if self.timeIntervalSince1970 == date.timeIntervalSince1970 {
            return true
        }
        return false
    }
    
    // MARK: - Formatted Dates
    // MARK: Formatted With Style
    /**
     *  Convenience method that returns a formatted string representing the receiver's date formatted to a given style
     *
     *  @param style DateFormatter.Style - Desired date formatting style
     *
     *  @return String representing the formatted date string
     */
    public func formattedDate(withStyle style: DateFormatter.Style) -> String {
        return self.formattedDate(withStyle: style, timeZone: TimeZone.current, locale: Locale.autoupdatingCurrent)
    }
    
    /**
     *  Convenience method that returns a formatted string representing the receiver's date formatted to a given style and time zone
     *
     *  @param style    DateFormatter.Style - Desired date formatting style
     *  @param timeZone TimeZone - Desired time zone
     *
     *  @return String representing the formatted date string
     */
    public func formattedDate(withStyle style: DateFormatter.Style, timeZone: TimeZone) -> String {
        return self.formattedDate(withStyle: style, timeZone: timeZone, locale: Locale.autoupdatingCurrent)
    }
    
    /**
     *  Convenience method that returns a formatted string representing the receiver's date formatted to a given style and locale
     *
     *  @param style  DateFormatter.Style - Desired date formatting style
     *  @param locale Locale - Desired locale
     *
     *  @return String representing the formatted date string
     */
    public func formattedDate(withStyle style: DateFormatter.Style, locale: Locale) -> String {
        return self.formattedDate(withStyle: style, timeZone: TimeZone.current, locale: locale)
    }
    
    /**
     *  Convenience method that returns a formatted string representing the receiver's date formatted to a given style, time zone and locale
     *
     *  @param style    DateFormatter.Style - Desired date formatting style
     *  @param timeZone TimeZone - Desired time zone
     *  @param locale   Locale - Desired locale
     *
     *  @return String representing the formatted date string
     */
    public func formattedDate(withStyle style: DateFormatter.Style, timeZone: TimeZone, locale: Locale) -> String {
        let formatter = DateFormatter()
        
        formatter.dateStyle = style
        formatter.timeZone = timeZone
        formatter.locale = locale
        return formatter.string(from: self)
    }
    
    // MARK: Formatted With Format
    /**
     *  Convenience method that returns a formatted string representing the receiver's date formatted to a given date format
     *
     *  @param format String - String representing the desired date format
     *
     *  @return String representing the formatted date string
     */
    public func formattedDate(withFormat format: String) -> String {
        return self.formattedDate(withFormat: format, timeZone: TimeZone.current, locale: Locale.autoupdatingCurrent)
    }
    
    /**
     *  Convenience method that returns a formatted string representing the receiver's date formatted to a given date format and time zone
     *
     *  @param format   String - String representing the desired date format
     *  @param timeZone TimeZone - Desired time zone
     *
     *  @return String representing the formatted date string
     */
    public func formattedDate(withFormat format: String, timeZone: TimeZone) -> String {
        return self.formattedDate(withFormat: format, timeZone: timeZone, locale: Locale.autoupdatingCurrent)
    }
    
    /**
     *  Convenience method that returns a formatted string representing the receiver's date formatted to a given date format and locale
     *
     *  @param format String - String representing the desired date format
     *  @param locale Locale - Desired locale
     *
     *  @return String representing the formatted date string
     */
    public func formattedDate(withFormat format: String, locale: Locale) -> String {
        return self.formattedDate(withFormat: format, timeZone: TimeZone.current, locale: locale)
    }
    
    /**
     *  Convenience method that returns a formatted string representing the receiver's date formatted to a given date format, time zone and locale
     *
     *  @param format   String - String representing the desired date format
     *  @param timeZone TimeZone - Desired time zone
     *  @param locale   Locale - Desired locale
     *
     *  @return String representing the formatted date string
     */
    public func formattedDate(withFormat format: String, timeZone: TimeZone, locale: Locale) -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        formatter.timeZone = timeZone
        formatter.locale = locale
        return formatter.string(from: self)
    }

}
