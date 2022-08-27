//
//  CDTask.swift
//  Countdown App
//
//  Created by Алексей Павленко on 27.08.2022.
//

import Foundation

struct CDTaskType {
    let symbolName: String
    let typeName: String
}

struct CDTask {
    var name: String
    var description: String
    var second: Int
    var taskType: CDTaskType
    
    var timeStamp: Double
}

enum CountDownState {
    case suspended
    case running
    case paused
}
