//
//  TimerIntervalJSON.swift
//  LocationApp
//
//  Created by Max Kuznetsov on 28.06.2022.
//

import Foundation

/*
 {
     "event":"interval_timer",
     "user_id":2342,
     "coords":
     [
         "x":789,
         "y":789
     ]
 }
 */

struct TimerIntervalJSON{
    let event: String
    let userId: Int
    let coords: [String:Double]
}
