//
//  ViewController.swift
//  Sample
//
//  Created by Meniny on 2017-08-01.
//  Copyright © 2017年 Meniny. All rights reserved.
//

import UIKit
import Dawn

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let now = Date()
        print("now: \(now)")
        print("now.isToday: \(now.isToday)")
        print("now.isWeekend: \(now.isWeekend)")
        print("now is: \(now.weekdayName.name)")
        
        let nextDay = now.adding(days: 1)
        print("nextDay: \(nextDay)")
        print("nextDay.isTomorrow: \(nextDay.isTomorrow)")
        
        let later = Dawn.compare(date: nextDay, ifLater: now)
        print("nextDay is isLaterThan now: \(later)")
        
        let todayInNextYear = Dawn.dateByAdding(1, of: .year, to: now)
        print("todayInNextYear: \(String(describing: todayInNextYear))")
    }


}

