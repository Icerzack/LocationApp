//
//  IntervalTimer.swift
//  LocationApp
//
//  Created by Max Kuznetsov on 18.07.2022.
//

import Foundation

protocol TimerProtocol {
    func getPossibleTimers() -> [String]
}

struct GlobalTimer: TimerProtocol {
    
    private var possibleGlobalTimers = ["30:00", "45:00", "1:00:00", "1:30:00", "2:00:00"]
    
    func getPossibleTimers() -> [String] {
        return possibleGlobalTimers
    }
   
}

struct IntervalTimer: TimerProtocol {
    
    private var possibleIntervalTimers = ["15:00"]
    
    func getPossibleTimers() -> [String] {
        return possibleIntervalTimers
    }
    
}
