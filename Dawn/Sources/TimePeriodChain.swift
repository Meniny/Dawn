//
//  TimePeriodChain.swift
//  Dawn
//
//  Copyright 2015 Meniny
//

import Foundation

open class TimePeriodChain: TimePeriodGroup {
    
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
        The start date of `TimePeriodChain` representing the starting boundary of the `TimePeriodChain`
    */
    open var startDate: Date?
    
    /**
        The end date of `TimePeriodChain` representing the ending boundary of the `TimePeriodChain`
    */
    open var endDate: Date?
    
    /**
        The earliest `TimePeriod` object in chain
    */
    open var first: TimePeriod? {
        get {
            return self.periods.first
        }
    }
    
    /**
        The latest `TimePeriod` object in chain
    */
    open var last: TimePeriod? {
        get {
            return self.periods.last
        }
    }
    
    /**
        Initializes an instance of `TimePeriodChain` using given calendar
    
        - parameter calendar: Calendar used for date calculations, defaults to `Calendar.current`
    */
    public init(calendar: Calendar = Calendar.current) {
        self.calendar = calendar
    }
    
    /**
        Appends given `TimePeriod` object at the end of the chain. This modifies `startDate` and `endDate` of `TimePeriod` to fit the chain.
    
        - parameter timePeriod: `TimePeriod` object to be added to the chain
    */
    open func add(timePeriod: TimePeriod) {
        if self.periods.count > 0 {
            let modifiedPeriod = TimePeriod(size: TimePeriodSize.second, amount: Int(timePeriod.durationInSeconds), startingAt: self.periods[self.periods.count - 1].endDate, calendar: self.calendar)
            self.periods.append(modifiedPeriod)
        } else {
            self.periods.append(timePeriod)
        }
    }
    
    /**
        Inserts given `TimePeriod` object at given index. Side effect of this method depends on index at which item is inserted.
        * When inserted at index 0 it prepends `TimePeriod` object to the chain, so that endDate of inserted `TimePeriod` object is equal to startDate of first element in the chain. Duration of `TimePeriod` parameter stays the same.
        * When inserted in the middle, this method shifts later all `TimePeriod` objects that have higher index than index given by the parameter, by the duration of given `TimePeriod` object. It also modifies `startDate` and `endDate` of given `TimePeriod` object to fit the chain.
        * When inserted at last index, this method appends given `TimePeriod` object modyfying `startDate` and `endDate` to fit the chain.
    
        - parameter timePeriod: `TimePeriod` object to be inserted
        - parameter index: index at which `TimePeriod` object has to be inserted
    */
    open func insert(timePeriod: TimePeriod, atIndex index: Int) {
        switch index {
        case 0 where self.periods.count == 0:
            self.add(timePeriod: timePeriod)
            
        case 0 where self.periods.count > 0:
            let modifiedPeriod = TimePeriod(size: TimePeriodSize.second, amount: Int(timePeriod.durationInSeconds), endingAt: self.periods[0].startDate, calendar: self.calendar)
            self.periods.insert(modifiedPeriod, at: 0)
            
        case let index where index <= self.periods.count:
            for (idx, period) in self.periods.enumerated() {
                if idx >= index {
                    period.shiftLater(withSize: TimePeriodSize.second, amount: Int(timePeriod.durationInSeconds))
                }
            }
            
            let modifiedPeriod = TimePeriod(size: TimePeriodSize.second, amount: Int(timePeriod.durationInSeconds), startingAt: self.periods[index - 1].endDate, calendar: self.calendar)
            
            self.periods.insert(modifiedPeriod, at: index)
        default:
            break
        }
    }
    
    /**
        Removes `TimePeriod` object at given index from the chain. This method shifts earlier all `TimePeriod` objects that have higher index than index given by the parameter, by duration of removed `TimePeriod` object.
    
        - parameter index: index of a `TimePeriod` object to be removed
    
        - returns: `Optional(TimePeriod)` removed from the chain, `nil` if object is not found
    */
    open func remove(atIndex index: Int) -> TimePeriod? {
        guard index >= 0 && index < self.periods.count else {
            return nil
        }
        
        let period = self.periods[index]
        
        for (idx, obj) in self.periods.enumerated() {
            if idx > index {
                obj.shiftEarlier(withSize: TimePeriodSize.second, amount: Int(period.durationInSeconds))
            }
        }
        
        self.periods.remove(at: index)
        
        return period
    }
    
    /**
        Removes latest `TimePeriod` object from the chain.
    
        - returns: `Optional(TimePeriod)` removed from the chain, `nil` if chain is empty
    */
    open func removeLatestTimePeriod() -> TimePeriod? {
        guard self.periods.count > 0 else {
            return nil
        }
        
        let period = self.periods.last
        self.periods.removeLast()
        
        return period
    }
    
    /**
        Removes earliest `TimePeriod` object from the chain. This method shifts earlier all `TimePeriod` objects in the chain, so that `startDate` stays the same.
    
        - returns: `Optional(TimePeriod)` removed from the chain, `nil` if chain is empty
    */
    open func removeEarliestTimePeriod() -> TimePeriod? {
        guard self.periods.count > 0 else {
            return nil
        }
        
        let period = self.periods.first        
        
        self.periods.forEach { elem in
            elem.shiftEarlier(withSize: TimePeriodSize.second, amount: Int(period!.durationInSeconds))
        }
        
        self.periods.removeFirst()
        
        return period
    }
    
    /**
        Compares given `TimePeriodChain` to the receiver and returns whether they are equal.
    
        - returns: true when chains are equal, false otherwise
    */
    open func equals(_ chain: TimePeriodChain) -> Bool {
        if !self.hasSameCharacteristicsAs(timePeriodGroup: chain) {
            return false
        }
        
        for (idx, period) in self.periods.enumerated() {
            if chain[idx] != period {
                return false
            }
        }
        
        return true
    }
    
    open func copy() -> TimePeriodChain {
        let chain = TimePeriodChain(calendar: self.calendar)
        for period in self.periods {
            chain.add(timePeriod: period)
        }
        return chain
    }

fileprivate func updateVariables() {
        self.startDate = self.periods.first?.startDate
        self.endDate = self.periods.last?.endDate
    }
    
}

public func == (lhs: TimePeriodChain, rhs: TimePeriodChain) -> Bool {
    return lhs.equals(rhs)
}

public func != (lhs: TimePeriodChain, rhs: TimePeriodChain) -> Bool {
    return !lhs.equals(rhs)
}

