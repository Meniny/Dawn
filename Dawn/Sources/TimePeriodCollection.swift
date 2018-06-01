//
//  TimePeriodCollection.swift
//  Dawn
//
//  Copyright 2015 Meniny
//

import Foundation

open class TimePeriodCollection: TimePeriodGroup {
    
    /**
       The start date of `TimePeriodCollection` representing the earliest date of TimePeriod objects.
     */
    open var startDate: Date?
    
    /**
       The end date of `TimePeriodCollection` representing the latest date of TimePeriod objects.
     */
    open var endDate: Date?
    
    open internal(set) var periods: [TimePeriod] = [] {
        didSet {
            self.updateVariables()
        }
    }
    
    public subscript(index: Int) -> TimePeriod {
        get {
            return self.periods[index]
        }
        set (value) {
            self.periods[index] = value
        }
    }
    
    open internal(set) var calendar: Calendar
    
    /**
       Initializes an instance of `TimePeriodCollection` using given calendar
    
       - parameter calendar: Calendar used for date calculations, defaults to `Calendar.current`
    
     */
    public init(calendar: Calendar = Calendar.current) {
        self.calendar = calendar
    }
    
    /**
        Appends given `TimePeriod` object to `TimePeriodCollection`
    
        - parameter timePeriod: `TimePeriod` object that will be added to collection
     */
    open func add(timePeriod: TimePeriod) {
            self.periods.append(timePeriod)
    }
    
    /**
        Inserts given `TimePeriod` object at given index
    
        - parameter timePeriod: `TimePeriod` object that will be inserted to collection
        - parameter index: index at which object will be inserted
    */
    open func insert(timePeriod: TimePeriod, atIndex index: Int) {
        guard index >= 0 && index <= self.periods.count else {
            return
        }
        
        self.periods.insert(timePeriod, at: index)
    }
    
    /**
        Removes `TimePeriod` at given index from collection
    
        - parameter index: index of a `TimePeriod` object in collection
    
        - returns: `Optional(TimePeriod)` removed from the chain, `nil` object is not found
    */
    open func remove(atIndex index: Int) -> TimePeriod? {
        guard index >= 0 && index < self.periods.count else {
            return nil
        }
        
        let period = self.periods[index]
        self.periods.remove(at: index)
        
        return period
    }
    
    /**
        Sorts collection by `startDate` in ascending order
    */
    open func sortByStartAscending() {
        self.periods.sort { (lhs, rhs) -> Bool in
            return lhs.startDate < rhs.startDate
        }
    }
    
    /**
        Sorts collection by `startDate` in descending order
    */
    open func sortByStartDescending() {
        self.periods.sort { (lhs, rhs) -> Bool in
            return lhs.startDate > rhs.startDate
        }
    }
    
    /**
        Sorts collection by `endDate` in ascending order
    */
    open func sortByEndAscending() {
        self.periods.sort { (lhs, rhs) -> Bool in
            return lhs.endDate < rhs.endDate
        }
    }
    
    /**
        Sorts collection by `endDate` in descending order
    */
    open func sortByEndDescending() {
        self.periods.sort { (lhs, rhs) -> Bool in
            return lhs.endDate > rhs.endDate
        }
    }
    
    /**
        Sorts collection by `TimePeriod` duration in ascending order
    */
    open func sortByDurationAscending() {
        self.periods.sort { (lhs, rhs) -> Bool in
            return lhs.durationInSeconds < rhs.durationInSeconds
        }
    }
    
    /**
        Sorts collection by `TimePeriod` duration in descending order
    */
    open func sortByDurationDescending() {
        self.periods.sort { (lhs, rhs) -> Bool in
            return lhs.durationInSeconds > rhs.durationInSeconds
        }
    }
    
    /**
        - parameter timePeriod: `TimePeriod` to check collection against
    
        - returns: `TimePeriodCollection` containing `TimePeriod` objects that are inside of given `TimePeriod`
    */
    open func periodsInside(period: TimePeriod) -> TimePeriodCollection {
        return self.periodsWithRelation(toPeriod: period, relation: TimePeriod.isInside)
    }
    
    /**
        - parameter date: date to check collection against
    
        - returns: `TimePeriodCollection` containing `TimePeriod` objects that intersect given date
    */
    open func periodsIntersected(byDate date: Date) -> TimePeriodCollection {
        let collection = TimePeriodCollection(calendar: self.calendar)
        
        self.periods.forEach { elem in
            if elem.contains(date: date, interval: TimePeriodInterval.closed) {
                collection.add(timePeriod: elem)
            }
        }
        
        return collection
    }
    
    /**
        - parameter timePeriod: `TimePeriod` to match collection against
    
        - returns: `TimePeriodCollection` containing `TimePeriod` objects that intersect given `TimePeriod`
    */
    open func periodsIntersected(byPeriod period: TimePeriod) -> TimePeriodCollection {
        return self.periodsWithRelation(toPeriod: period, relation: TimePeriod.intersects)
    }

    /**
        - parameter timePeriod: `TimePeriod` to match collection against
    
        - returns: `TimePeriodCollection` containing `TimePeriod` objects that are overlapped by given `TimePeriod`. This covers all space they share, minus instantaneous space (i.e. one's start date equals another's end date)
    */
    open func periodsOverlapped(byPeriod period: TimePeriod) -> TimePeriodCollection {
        return self.periodsWithRelation(toPeriod: period, relation: TimePeriod.overlapsWith)
    }
    
    /**
        Compares given `TimePeriodCollection` to the receiver and returns whether they are equal. Comparison can be done with order considering or without.
    
        - parameter collection: `TimePeriodCollection` object to compare to receiver
        - parameter considerOrder: Is order considered during comparison
    
        - returns: true when collections are equal, false otherwise
    */
    open func equals(_ collection: TimePeriodCollection, considerOrder: Bool = false) -> Bool {
        if !self.hasSameCharacteristicsAs(timePeriodGroup: collection) {
            return false
        }
        
        if considerOrder {
            return self.isEqualToCollectionConsideringOrder(collection)
        } else {
            return self.isEqualToCollectionNotConsideringOrder(collection)
        } 
    }
    
     open func copy() -> TimePeriodCollection {
        let collection = TimePeriodCollection(calendar: self.calendar)
        for period in self.periods {
            collection.add(timePeriod: period)
        }
        return collection
     }
    
    //MARK: - Private
    
    fileprivate func isEqualToCollectionConsideringOrder(_ collection: TimePeriodCollection) -> Bool {
        for (idx, period) in self.periods.enumerated() {
            if collection[idx] != period {
                return false
            }
        }
        return true
    }
    
    fileprivate func isEqualToCollectionNotConsideringOrder(_ collection: TimePeriodCollection) -> Bool {
        for period in self.periods {
            if collection.periods.filter({ elem -> Bool in
                return elem == period
            }).count == 0 {
                return false
            }
        }
        return true
    }
    
    fileprivate func periodsWithRelation(toPeriod period: TimePeriod, relation: (TimePeriod) -> (TimePeriod) -> Bool) -> TimePeriodCollection {
        let collection = TimePeriodCollection(calendar: self.calendar)
        
        self.periods.forEach { elem in
            if relation(elem)(period) {
                collection.add(timePeriod: elem)
            }
        }
        
        return collection
    }
    
    fileprivate func updateVariables() {
        self.startDate = Date.distantFuture
        self.endDate = Date.distantPast
        
        for period in self.periods {
            if self.startDate! > period.startDate {
                self.startDate = period.startDate
            }
            if self.endDate! < period.endDate {
                self.endDate = period.endDate
            }
        }
        if self.periods.isEmpty {
            self.startDate = nil
            self.endDate = nil
        }
    }
}

public func == (lhs: TimePeriodCollection, rhs: TimePeriodCollection) -> Bool {
    return lhs.equals(rhs)
}

public func != (lhs: TimePeriodCollection, rhs: TimePeriodCollection) -> Bool {
    return !lhs.equals(rhs)
}
