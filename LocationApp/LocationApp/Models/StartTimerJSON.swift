//
//  StartTimerJSON.swift
//  LocationApp
//
//  Created by Max Kuznetsov on 28.06.2022.
//

import Foundation

struct StartTimerJSON: Codable{
    let event: String
    let userId: Int
    let timer: Date
}
