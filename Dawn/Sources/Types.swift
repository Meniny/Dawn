//
//  Constants.swift
//  Dawn
//
//  Copyright 2015 Meniny
//

import Foundation

public enum SecondsConstant: UInt, Equatable, Codable {
    case year = 31556900
    case month28 = 2419200
    case month29 = 2505600
    case month30 = 2592000
    case month31 = 2678400
    case week = 604800
    case day = 86400
    case hour = 3600
    case minute = 60
}

public extension Calendar.Component {
    public static let all: Set<Calendar.Component> = [
        .era, .year, .quarter, .month, .day,
        .hour, .second, .minute, .weekday, .weekdayOrdinal,
        .weekOfMonth, .weekOfYear, .yearForWeekOfYear,
        .calendar, .timeZone
    ]
}

public enum WeekdayName: Int, Equatable, Codable {
    /// 星期一 Mon.
    case monday = 0
    /// 星期二 Tues.
    case tuesday = 1
    /// 星期三 Wed.
    case wednesday = 2
    /// 星期四 Thur.
    case thursday = 3
    /// 星期五 Fri.
    case friday = 4
    /// 星期六 Sat.
    case saturday = 5
    /// 星期天 Sun.
    case sunday = 6
    
    public var name: String {
        switch self {
        case .sunday:
            return "Sunday"
        case .monday:
            return "Monday"
        case .tuesday:
            return "Tuesday"
        case .wednesday:
            return "Wednesday"
        case .thursday:
            return "Thursday"
        case .friday:
            return "Friday"
        default:
            return "Saturday"
        }
    }
    
    public var shortName: String {
        switch self {
        case .sunday:
            return "Sun."
        case .monday:
            return "Mon."
        case .tuesday:
            return "Tues."
        case .wednesday:
            return "Wed."
        case .thursday:
            return "Thur."
        case .friday:
            return "Fri."
        default:
            return "Sat."
        }
    }
}

public enum DateCountingUnit {
    case years, months, weeks, days
    
    public var components: Set<Calendar.Component> {
        switch self {
        case .years:
            return [Calendar.Component.year]
        case .months:
            return [
                .year, .quarter, .month, .day,
                .hour, .second, .minute,
                .weekday, .weekdayOrdinal, .weekOfMonth, .weekOfYear,
                .yearForWeekOfYear
            ]
        case .weeks:
            return [Calendar.Component.weekOfYear]
        default:
            return [Calendar.Component.day]
        }
    }
}

public func DawnLocalizedStrings(_ key: String) -> String {
    let bundle = Bundle(url: Bundle(for: TimePeriodCollection.self).resourceURL!.appendingPathComponent("Dawn.bundle"))!
    return NSLocalizedString(key, tableName: "Dawn", bundle: bundle, comment: key)
}

public enum DawnDateComponent: UInt, Equatable, Codable {
    case era
    case year
    case month
    case day
    case hour
    case minute
    case second
    case weekday
    case weekdayOrdinal
    case quarter
    case weekOfMonth
    case weekOfYear
    case yearForWeekOfYear
    case dayOfYear
}

public enum DateAgoFormat: UInt, Equatable, Codable {
    case long
    case longUsingNumericDatesAndTimes
    case longUsingNumericDates
    case longUsingNumericTimes
    case short
    case week
}

public enum DateAgoUnit: UInt, Equatable, Codable {
    case years
    case months
    case weeks
    case days
    case hours
    case minutes
    case seconds
}

public enum TimePeriodRelation: UInt, Equatable, Codable {
    case after
    case startTouching
    case startInside
    case insideStartTouching
    case enclosingStartTouching
    case enclosing
    case enclosingEndTouching
    case exactMatch
    case inside
    case insideEndTouching
    case endInside
    case endTouching
    case before
    case none // One or more of the dates does not exist
}

public enum TimePeriodSize: UInt, Equatable, Codable {
    case second
    case minute
    case hour
    case day
    case week
    case month
    case year
}

public enum TimeCalculatingOperation: String, Equatable, Codable {
    case adding, subtracting
}

public enum TimePeriodInterval: UInt, Equatable, Codable {
    case open
    case closed
}

public enum TimePeriodAnchor: UInt, Equatable, Codable {
    case start
    case center
    case end
}
